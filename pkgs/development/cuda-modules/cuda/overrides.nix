# NOTE(@connorbaker): None of the functions in this attribute set should need to access _final or _prev.
# As such, they are prefixed with an underscore -- everything should be doable with the spliced package sets
# provided to each function in the attribute set by `final.callPackage`.
let
  filterAndCreateOverrides =
    createOverrideAttrs: final: prev:
    let
      # It is imperative that we use `final.callPackage` to create these overrides, as it allows us access to the spliced
      # package sets.
      inherit (final) callPackage;

      # NOTE(@connorbaker): We MUST use `lib` from `prev` because the attribute names CAN NOT depend on `final`.
      inherit (prev.lib.attrsets) filterAttrs mapAttrs;
      inherit (prev.lib.trivial) pipe;
    in
    pipe createOverrideAttrs [
      # NOTE: Filter out attributes that are not present in the previous version of
      # the package set. This is necessary to prevent the appearance of attributes
      # like `cuda_nvcc` in `cudaPackages_10_0, which predates redistributables.
      (filterAttrs (name: _: prev ? ${name}))
      # NOTE: It is imperative that we use `final.callPackage` to perform overrides,
      # as it allows us access to the spliced package sets.
      # Pass the previous version of the package to the override function.
      (mapAttrs (name: value: callPackage value { ${name} = prev.${name}; }))
    ];
in
filterAndCreateOverrides {
  libcufile =
    {
      cudaOlder,
      lib,
      libcublas,
      libcufile,
      numactl,
      rdma-core,
    }:
    libcufile.overrideAttrs (
      prevAttrs: {
        buildInputs = prevAttrs.buildInputs ++ [
          libcublas.lib
          numactl
          rdma-core
        ];
        # Before 11.7 libcufile depends on itself for some reason.
        autoPatchelfIgnoreMissingDeps =
          prevAttrs.autoPatchelfIgnoreMissingDeps
          ++ lib.lists.optionals (cudaOlder "11.7") [ "libcufile.so.0" ];
      }
    );

  libcusolver =
    {
      cudaAtLeast,
      lib,
      libcublas,
      libcusolver,
      libcusparse ? null,
      libnvjitlink ? null,
    }:
    libcusolver.overrideAttrs (
      prevAttrs: {
        buildInputs =
          prevAttrs.buildInputs
          # Always depends on this
          ++ [ libcublas.lib ]
          # Dependency from 12.0 and on
          ++ lib.lists.optionals (cudaAtLeast "12.0") [ libnvjitlink.lib ]
          # Dependency from 12.1 and on
          ++ lib.lists.optionals (cudaAtLeast "12.1") [ libcusparse.lib ];
      }
    );

  libcusparse =
    {
      cudaAtLeast,
      lib,
      libcusparse,
      libnvjitlink ? null,
    }:
    libcusparse.overrideAttrs (
      prevAttrs: {
        buildInputs =
          prevAttrs.buildInputs
          # Dependency from 12.0 and on
          ++ lib.lists.optionals (cudaAtLeast "12.0") [ libnvjitlink.lib ];
      }
    );

  cuda_cudart =
    {
      buildPackages,
      cuda_cudart,
      lib,
    }:
    cuda_cudart.overrideAttrs (
      prevAttrs: {
        # Remove once cuda-find-redist-features has a special case for libcuda
        outputs =
          prevAttrs.outputs
          ++ lib.lists.optionals (!(builtins.elem "stubs" prevAttrs.outputs)) [ "stubs" ];

        allowFHSReferences = false;

        # The libcuda stub's pkg-config doesn't follow the general pattern:
        postPatch =
          prevAttrs.postPatch or ""
          + ''
            while IFS= read -r -d $'\0' path ; do
              sed -i \
                -e "s|^libdir\s*=.*/lib\$|libdir=''${!outputLib}/lib/stubs|" \
                -e "s|^Libs\s*:\(.*\)\$|Libs: \1 -Wl,-rpath,${buildPackages.addDriverRunpath.driverLink}/lib|" \
                "$path"
            done < <(find -iname 'cuda-*.pc' -print0)
          ''
          + ''
            # Namelink may not be enough, add a soname.
            # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/25536
            if [[ -f lib/stubs/libcuda.so && ! -f lib/stubs/libcuda.so.1 ]] ; then
              ln -s libcuda.so lib/stubs/libcuda.so.1
            fi
          '';

        postFixup =
          prevAttrs.postFixup or ""
          + ''
            moveToOutput lib/stubs "$stubs"
            ln -s "$stubs"/lib/stubs/* "$stubs"/lib/
            ln -s "$stubs"/lib/stubs "''${!outputLib}/lib/stubs"
          '';
      }
    );

  cuda_compat =
    {
      cuda_compat,
      flags,
      lib,
    }:
    cuda_compat.overrideAttrs (
      prevAttrs: {
        autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps ++ [
          "libnvrm_gpu.so"
          "libnvrm_mem.so"
          "libnvdla_runtime.so"
        ];
        # `cuda_compat` only works on aarch64-linux, and only when building for Jetson devices.
        badPlatformsConditions = prevAttrs.badPlatformsConditions // {
          "Trying to use cuda_compat on aarch64-linux targeting non-Jetson devices" = !flags.isJetsonBuild;
        };
        meta = prevAttrs.meta // {
          # For cross-compilation, we need the hostPlatform to be included in order to fetch and build the package. This
          # doesn't change the fact that it won't work on non-Jetson devices, so we only add it when building for Jetson.
          platforms = prevAttrs.meta.platforms ++ lib.lists.optionals flags.isJetsonBuild [ "x86_64-linux" ];
        };
      }
    );

  cuda_gdb =
    {
      cuda_gdb,
      cudaAtLeast,
      gmp,
      lib,
    }:
    cuda_gdb.overrideAttrs (
      prevAttrs: {
        buildInputs =
          prevAttrs.buildInputs
          # x86_64 only needs gmp from 12.0 and on
          ++ lib.lists.optionals (cudaAtLeast "11.0") [ gmp ];
      }
    );

  cuda_nvcc =
    {
      backendStdenv,
      buildPackages,
      cuda_cudart,
      cuda_nvcc,
      cudaAtLeast,
      cudaOlder,
      lib,
      setupCudaHook,
    }:
    cuda_nvcc.overrideAttrs (
      prevAttrs: {
        # Remove once cuda-find-redist-features has a special case for libcuda
        # TODO(@connorbaker): The order of build outputs matters as we traverse them when creating split outputs.
        # The `lib` output cannot come after `static` as it moves all the static libraries back to the `lib` output.
        outputs =
          prevAttrs.outputs
          ++ lib.lists.optionals (!(builtins.elem "lib" prevAttrs.outputs)) [ "lib" ];

        # Patch the nvcc.profile.
        # Syntax:
        # - `=` for assignment,
        # - `?=` for conditional assignment,
        # - `+=` to "prepend",
        # - `=+` to "append".

        # Cf. https://web.archive.org/web/20230308044351/https://arcb.csc.ncsu.edu/~mueller/cluster/nvidia/2.0/nvcc_2.0.pdf

        # We set all variables with the lowest priority (=+), but we do force
        # nvcc to use the fixed backend toolchain. Cf. comments in
        # backend-stdenv.nix

        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ backendStdenv.cc ];

        # TODO(@connorbaker): We should specify the spliced version of backendStdenv and cuda_cudart to use here.
        postPatch =
          (prevAttrs.postPatch or "")
          + ''
            echo "Running the cuda_nvcc postPatch"
            substituteInPlace bin/nvcc.profile \
              --replace \
                '$(TOP)/lib' \
                "''${!outputLib}/lib" \
              --replace \
                '$(TOP)/$(_NVVM_BRANCH_)' \
                "''${!outputBin}/nvvm" \
              --replace \
                '$(TOP)/$(_TARGET_DIR_)/include' \
                "''${!outputDev}/include"

            cat << EOF >> bin/nvcc.profile

            # Fix a compatible backend compiler
            PATH += ${lib.getBin backendStdenv.cc}/bin:

            # Expose the split-out nvvm
            LIBRARIES =+ -L''${!outputBin}/nvvm/lib
            INCLUDES =+ -I''${!outputBin}/nvvm/include

            # Expose cudart and the libcuda stubs
            LIBRARIES =+ -L$static/lib" "-L${cuda_cudart.lib}/lib -L${cuda_cudart.lib}/lib/stubs
            INCLUDES =+ -I${cuda_cudart.dev}/include
            EOF
          '';

        propagatedNativeBuildInputs = [ setupCudaHook ];

        postInstall =
          (prevAttrs.postInstall or "")
          + ''
            moveToOutput "nvvm" "''${!outputBin}"
          '';

        # The nvcc and cicc binaries contain hard-coded references to /usr
        allowFHSReferences = true;

        meta = (prevAttrs.meta or { }) // {
          mainProgram = "nvcc";
        };
      }
    );

  cuda_nvprof =
    { cuda_cupti, cuda_nvprof }:
    cuda_nvprof.overrideAttrs (
      prevAttrs: { buildInputs = prevAttrs.buildInputs ++ [ cuda_cupti.lib ]; }
    );

  cuda_demo_suite =
    {
      cuda_demo_suite,
      freeglut,
      lib,
      libcufft,
      libcurand,
      libGLU,
      libglvnd,
      mesa,
    }:
    cuda_demo_suite.overrideAttrs (
      prevAttrs: {
        buildInputs = prevAttrs.buildInputs ++ [
          freeglut
          libcufft.lib
          libcurand.lib
          libGLU
          libglvnd
          mesa
        ];
      }
    );

  nsight_compute =
    {
      lib,
      nsight_compute,
      qt5 ? null,
      qt6 ? null,
    }:
    nsight_compute.overrideAttrs (
      prevAttrs: {
        nativeBuildInputs =
          prevAttrs.nativeBuildInputs
          ++ (
            if (lib.strings.versionOlder prevAttrs.version "2022.2.0") then
              [ qt5.wrapQtAppsHook ]
            else
              [ qt6.wrapQtAppsHook ]
          );
        buildInputs =
          prevAttrs.buildInputs
          ++ (
            if (lib.strings.versionOlder prevAttrs.version "2022.2.0") then
              [ qt5.qtwebview ]
            else
              [ qt6.qtwebview ]
          );
      }
    );

  nsight_systems =
    {
      alsa-lib,
      boost178,
      cuda_cudart,
      cudaOlder,
      e2fsprogs,
      gst_all_1,
      lib,
      nsight_systems,
      nss,
      numactl,
      pulseaudio,
      qt5 ? null,
      qt6 ? null,
      rdma-core,
      ucx,
      wayland,
      xorg,
    }:
    nsight_systems.overrideAttrs (
      prevAttrs:
      let
        qt = if lib.strings.versionOlder prevAttrs.version "2022.4.2.1" then qt5 else qt6;
        qtwayland =
          if lib.versions.major qt.qtbase.version == "5" then
            lib.getBin qt.qtwayland
          else
            lib.getLib qt.qtwayland;
        qtWaylandPlugins = "${qtwayland}/${qt.qtbase.qtPluginPrefix}";
      in
      {
        # An ad hoc replacement for
        # https://github.com/ConnorBaker/cuda-redist-find-features/issues/11
        env.rmPatterns = toString [
          "nsight-systems/*/*/libQt*"
          "nsight-systems/*/*/libstdc*"
          "nsight-systems/*/*/libboost*"
          "nsight-systems/*/*/lib{ssl,ssh,crypto}*"
          "nsight-systems/*/*/lib{arrow,jpeg}*"
          "nsight-systems/*/*/Mesa"
          "nsight-systems/*/*/python/bin/python"
          "nsight-systems/*/*/libexec"
          "nsight-systems/*/*/Plugins"
        ];
        postPatch =
          prevAttrs.postPatch or ""
          + ''
            for path in $rmPatterns ; do
              rm -r "$path"
            done
          '';
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ qt.wrapQtAppsHook ];
        buildInputs = prevAttrs.buildInputs ++ [
          (qt.qtdeclarative or qt.full)
          (qt.qtsvg or qt.full)
          cuda_cudart.stubs
          gst_all_1.gst-plugins-base
          gst_all_1.gstreamer
          nss
          numactl
          pulseaudio
          qt.qtbase
          qtWaylandPlugins
          rdma-core
          ucx
          wayland
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXrandr
          xorg.libXtst
        ];

        # Older releases require boost 1.70 deprecated in Nixpkgs
        meta.broken = prevAttrs.meta.broken or false || cudaOlder "11.8";
      }
    );

  nvidia_driver =
    { nvidia_driver }:
    nvidia_driver.overrideAttrs {
      # No need to support this package as we have drivers already
      # in linuxPackages.
      meta.broken = true;
    };
}
