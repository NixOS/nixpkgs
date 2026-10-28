{
  pkgs,
  xla ? pkgs.xla.override { cudaSupport = false; },
  cudaSupport ? xla.cudaSupport or false,
  cudaPackages ? pkgs.cudaPackages,
  cudaRuntimeLibs ? [ ],
}:
let
  inherit (pkgs) lib;
  runner = pkgs.stdenv.mkDerivation {
    pname = "xla-pjrt-execute";
    inherit (xla) version;
    dontUnpack = true;
    buildPhase = ''
      runHook preBuild
      $CXX -std=c++17 -Wall -Wextra -Werror -O2 \
        -I${xla}/include ${./pjrt-execute.cc} -ldl -o pjrt-execute
      for platform in cpu ${lib.optionalString cudaSupport "gpu"}; do
        printf '#include "xla/pjrt/c/pjrt_c_api_%s.h"\n' "$platform" > header.cc
        $CXX -std=c++17 -Wall -Wextra -Werror -I${xla}/include -fsyntax-only header.cc
      done
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      install -Dm755 pjrt-execute $out/bin/pjrt-execute
      runHook postInstall
    '';
    meta.mainProgram = "pjrt-execute";
  };

  pjrtTester =
    platform:
    pkgs.writeShellApplication {
      name = "xla-pjrt-${platform}";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.gnugrep
      ];
      text = ''
        ${lib.optionalString (platform == "cuda") ''
          # Exercise the installed package's compiled-in toolkit discovery.
          # The host driver remains available through the plugin's RUNPATH.
          export PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.gnugrep
            ]
          }
          unset XLA_FLAGS CUDA_HOME CUDA_PATH LD_LIBRARY_PATH
        ''}
        exec ${pkgs.bash}/bin/bash ${./pjrt-check.sh} \
          ${lib.getExe runner} \
          ${xla}/lib/pjrt_c_api_${if platform == "cuda" then "gpu" else "cpu"}_plugin.so \
          ${platform} "$@"
      '';
    };

  ncclRunner = pkgs.stdenv.mkDerivation {
    pname = "xla-nccl-smoke";
    inherit (xla) version;
    dontUnpack = true;
    buildPhase = ''
      runHook preBuild
      $CXX -std=c++17 -Wall -Wextra -Werror -O2 \
        -I${lib.getInclude cudaPackages.cuda_cudart}/include \
        -I${cudaPackages.cuda_nvcc}/include \
        -I${lib.getInclude cudaPackages.cccl}/include \
        -I${lib.getDev cudaPackages.nccl}/include \
        ${./nccl-smoke.cc} \
        -L${lib.getLib cudaPackages.cuda_cudart}/lib \
        -L${lib.getLib cudaPackages.nccl}/lib \
        -lcudart -lnccl -o nccl-smoke
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      install -Dm755 nccl-smoke $out/bin/nccl-smoke
      runHook postInstall
    '';
    meta.mainProgram = "nccl-smoke";
  };

  ncclTester = pkgs.writeShellApplication {
    name = "xla-nccl";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = ''
      logs=''${1:-$(mktemp -d -t xla-nccl.XXXXXXXX)}
      mkdir -p "$logs"
      export LD_LIBRARY_PATH="${pkgs.addDriverRunpath.driverLink}/lib:${lib.getLib cudaPackages.cuda_cudart}/lib:${lib.getLib cudaPackages.nccl}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      ${lib.getExe ncclRunner} 2>&1 | tee "$logs/nccl.log"
      grep -E '^PASS NCCL [0-9]+ one-rank all-reduce: 7$' "$logs/nccl.log"
    '';
  };

  hloTester = pkgs.writeShellApplication {
    name = "xla-hlo";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = ''
      logs=''${1:-$(mktemp -d -t xla-hlo.XXXXXXXX)}
      mkdir -p "$logs"
      ${lib.optionalString cudaSupport ''
        # Even Host/Interpreter need the CUDA CLI's direct libcuda dependency.
        export LD_LIBRARY_PATH="${pkgs.addDriverRunpath.driverLink}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      ''}
      ${xla}/bin/run_hlo_module --platform=Host --reference_platform=Interpreter \
        ${./smoke.hlo} 2>&1 | tee "$logs/hlo.log"
      grep -F 'Results on Host and Interpreter are close enough.' "$logs/hlo.log"
      grep -Fx '0/1 runs failed.' "$logs/hlo.log"
    '';
  };

  runtimeClosure = pkgs.closureInfo { rootPaths = [ xla ]; };
  installConfig = pkgs.writeText "xla-install-check.json" (
    builtins.toJSON {
      package = xla;
      inherit cudaSupport;
      closure = "${runtimeClosure}/store-paths";
      driverRunpath = "${pkgs.addDriverRunpath.driverLink}/lib";
      runtimeRunpaths = map (p: "${p}/lib") cudaRuntimeLibs;
      pluginRunpaths = lib.optionals cudaSupport (
        map (p: "${lib.getLib p}/lib") [
          cudaPackages.cuda_cudart
          cudaPackages.cudnn
          cudaPackages.nccl
        ]
      );
      cudaToolRoot = lib.optionalString cudaSupport (toString cudaPackages.cuda_nvcc);
      cudaToolArtifacts = lib.optionals cudaSupport [
        "bin/ptxas"
        "bin/nvlink"
        "nvvm/libdevice/libdevice.10.bc"
      ];
      # The full selected nvcc output intentionally retains its wrapped host GCC.
      # Keep excluding unrelated build roots, including the build stdenv wrapper;
      # comparing names must not realize the forbidden inputs themselves.
      forbiddenPaths = map (p: builtins.unsafeDiscardStringContext (toString p)) [
        xla.src
        xla.deps
        pkgs.bazel_7
        pkgs.stdenv.cc
      ];
    }
  );
  installTester = pkgs.writeShellApplication {
    name = "xla-install";
    runtimeInputs = [
      pkgs.python3
      pkgs.binutils
      pkgs.patchelf
      pkgs.glibc.bin
    ];
    text = ''
      exec python3 ${./install-check.py} ${installConfig} "$@"
    '';
  };

  check =
    name: tester: features:
    pkgs.runCommand "xla-${name}"
      {
        requiredSystemFeatures = features;
      }
      ''
        ${lib.getExe tester} "$out"
      '';
  metadata =
    assert lib.elem lib.licenses.asl20 xla.meta.license;
    assert cudaSupport == lib.any (license: !(license.free or true)) xla.meta.license;
    assert
      !cudaSupport
      || (
        lib.elem lib.licenses.nvidiaCudaRedist xla.meta.license
        && lib.all (license: lib.elem license xla.meta.license) cudaPackages.cudnn.meta.license
      );
    pkgs.runCommand "xla-metadata" { } ''touch "$out"'';
in
{
  inherit runner;
  testers = {
    pjrt = pjrtTester "cpu";
  }
  // lib.optionalAttrs (!cudaSupport) {
    hlo = hloTester;
    install = installTester;
  }
  // {
    cuda = lib.optionalAttrs cudaSupport {
      pjrt = pjrtTester "cuda";
      nccl = ncclTester;
      hlo = hloTester;
      install = installTester;
    };
  };

  tests = {
    cpu = check "pjrt-cpu" (pjrtTester "cpu") [ ];
  }
  // lib.optionalAttrs (!cudaSupport) {
    hlo = check "hlo" hloTester [ ];
    install = check "install" installTester [ ];
    inherit metadata;
  }
  // {
    cuda = lib.optionalAttrs cudaSupport {
      pjrt = check "pjrt-cuda" (pjrtTester "cuda") [ "cuda" ];
      nccl = check "nccl-cuda" ncclTester [ "cuda" ];
      hlo = check "hlo-cuda" hloTester [ "cuda" ];
      install = check "install-cuda" installTester [ ];
      configure = pkgs.callPackage ./cuda-configure.nix { inherit xla cudaPackages; };
      configureOverride =
        let
          selectedCudaPackages = cudaPackages // {
            cuda_nvcc = cudaPackages.cuda_nvcc.overrideAttrs (previousAttrs: {
              postInstall = (previousAttrs.postInstall or "") + ''
                echo '#define XLA_SELECTED_OUTPUT 964' > "$out/include/xla-selected-output.h"
              '';
            });
            nccl = cudaPackages.nccl.overrideAttrs (previousAttrs: {
              postInstall = (previousAttrs.postInstall or "") + ''
                echo '#define XLA_SELECTED_NCCL_OUTPUT 1' > "$out/include/xla-selected-nccl-output.h"
              '';
            });
          };
          # finalAttrs.finalPackage keeps downstream overrideAttrs linked into
          # passthru tests, but it cannot expose callPackage's outer `override`.
          # Update only the selected-package paths while retaining that linkage.
          local = pkgs.callPackage ../cuda-local.nix { inherit cudaPackages; };
          selectedLocal = pkgs.callPackage ../cuda-local.nix { cudaPackages = selectedCudaPackages; };
          replaceSelectedPaths =
            lib.replaceStrings
              [
                (toString local.cuda)
                (toString local.nccl)
                (toString cudaPackages.cuda_nvcc)
              ]
              [
                (toString selectedLocal.cuda)
                (toString selectedLocal.nccl)
                (toString selectedCudaPackages.cuda_nvcc)
              ];
          selectedXla = xla.overrideAttrs (previousAttrs: {
            preConfigure = replaceSelectedPaths previousAttrs.preConfigure;
            postConfigure = replaceSelectedPaths previousAttrs.postConfigure;
          });
        in
        pkgs.callPackage ./cuda-configure.nix {
          xla = selectedXla;
          cudaPackages = selectedCudaPackages;
          expectSelectedOutput = true;
        };
      configureChecker = pkgs.runCommand "xla-cuda-configure-checker" { } ''
        ${lib.getExe pkgs.python3} ${./cuda-configure-check-test.py} ${./cuda-configure-check.py} -v \
          > "$out" 2>&1

        mkdir -p driver-valid/lib driver-copied-stub/lib driver-linked-stub/lib
        printf 'real driver fixture' > driver-valid/lib/libcuda.so.1
        printf 'toolkit stub fixture' > toolkit-stub.so
        cp toolkit-stub.so driver-copied-stub/lib/libcuda.so.1
        ln -s "$PWD/toolkit-stub.so" driver-linked-stub/lib/libcuda.so.1
        ${pkgs.bash}/bin/bash ${./cuda-driver-check.sh} driver-valid toolkit-stub.so
        if ${pkgs.bash}/bin/bash ${./cuda-driver-check.sh} driver-missing toolkit-stub.so; then
          echo "missing driver repository passed validation" >&2
          exit 1
        fi
        if ${pkgs.bash}/bin/bash ${./cuda-driver-check.sh} driver-copied-stub toolkit-stub.so; then
          echo "copied toolkit stub passed as a real driver" >&2
          exit 1
        fi
        if ${pkgs.bash}/bin/bash ${./cuda-driver-check.sh} driver-linked-stub toolkit-stub.so; then
          echo "linked toolkit stub passed as a real driver" >&2
          exit 1
        fi
      '';
      inherit metadata;
    };
  };
}
