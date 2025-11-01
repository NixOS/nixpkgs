{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  python3,
  tt-metal,
  sphinx,
  doxygen,
  graphviz,
  gtest,
  protobuf_21,
  flatbuffers,
  buildPackages,
  targetPackages,
  llvmPackages_21,
  git,
  blas,
  capstone,
  pkg-config,
  pkgsStatic,
}@pkgs:
let
  python-env = python3.withPackages (
    pythonPackages: with pythonPackages; [
      distutils
      pybind11
      pip
      torch
      setuptools
      wheel
      build
      click
      nanobind
      installer
    ]
  );

  flatbuffers_24 = flatbuffers.overrideAttrs (
    f: p: {
      version = "24.3.25";

      src = fetchFromGitHub {
        owner = "google";
        repo = "flatbuffers";
        rev = "v${f.version}";
        hash = "sha256-uE9CQnhzVgOweYLhWPn2hvzXHyBbFiFVESJ1AEM3BmA=";
      };
    }
  );

  protobuf_21 =
    (pkgsStatic.protobuf_21.overrideAttrs (
      f: p: {
        version = "21.12";

        src = fetchFromGitHub {
          owner = "protocolbuffers";
          repo = "protobuf";
          tag = "v21.12";
          hash = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
        };
      }
    )).override
      {
        abseil-cpp = pkgsStatic.abseil-cpp;
      };

  tt-metal =
    (pkgs.tt-metal.overrideAttrs (
      f: p: {
        # Must be set to this or else the version parsing fails
        version = "0.63.0";

        src = fetchFromGitHub {
          owner = "tenstorrent";
          repo = "tt-metal";
          rev = "aa1920c90df3b4f973adb2142217aed72ca25ebe";
          fetchSubmodules = true;
          hash = "sha256-/fW60xMyRGA4P6vFXIdy02T5Q5v/Tllbnjo5XZjkyB0=";
        };

        postPatch = p.postPatch + ''
          cp ${./sfpi-version.sh} tt_metal/sfpi-version.sh

          chmod +x tt_metal/llrt/hal/codegen/codegen.sh
          patchShebangs tt_metal/llrt/hal/codegen/codegen.sh
        '';

        preConfigure = p.preConfigure + ''
          # For some reason, protobuf tries to find things here on install.
          mkdir -p build/_deps/protobuf-build/nix
          ln -s /nix/store build/_deps/protobuf-build/nix/store
        '';

        passthru.deps = p.passthru.deps // {
          protobuf = protobuf_21.src;
        };
      }
    )).override
      {
        stdenv = clangStdenv;
      };
in
clangStdenv.mkDerivation (
  finalAttrs:
  let
    inherit (finalAttrs.passthru) llvmPackages;
  in
  {
    pname = "tt-mlir";
    version = "0.4.0.dev20250920";

    src = fetchFromGitHub {
      owner = "tenstorrent";
      repo = "tt-mlir";
      tag = finalAttrs.version;
      hash = "sha256-51tygkRLzb6XXCeZ1Fg/uN51qdM3xYdjMozFcuolBts=";
    };

    METAL_SRC_DIR = tt-metal.src;
    METAL_LIB_DIR = "${tt-metal}/lib";

    TTMLIR_TOOLCHAIN_DIR = placeholder "out";
    TTMLIR_ENV_ACTIVATED = 1;

    inherit (tt-metal) cpm;

    patches = [
      ./fix-python.diff
      ./fix-version.diff
      ./fix-system-header-prefix.diff
      ./fix-ttnn-dialect-pipelines.diff
      ./add-metal-config-args.diff
      ./add-model-explorer-source.diff
      ./fix-metal.diff
      ./fix-tt-stl.diff
      ./fix-runtime.diff
      ./fix-linking-order.patch
    ];

    postUnpack = ''
      chmod +x $sourceRoot/tools/scripts/sha256-include-gen.py
      patchShebangs $sourceRoot/tools/scripts/sha256-include-gen.py

      # tt-mlir wants a built version of tt-metal but also the source code.
      mkdir -p $sourceRoot/third_party/tt-metal/src/
      cp -r ${tt-metal.src} $sourceRoot/third_party/tt-metal/src/tt-metal
      chmod -R u+w $sourceRoot/third_party/tt-metal/src/tt-metal

      mkdir -p $sourceRoot/build/tt_metal
      ln -s $sourceRoot/third_party/tt-metal/src/tt-metal/build $sourceRoot/build/tt_metal

      mkdir -p "$sourceRoot/third_party/tt-metal/src/tt-metal/runtime"
      ln -s "${tt-metal.sfpi}" "$sourceRoot/third_party/tt-metal/src/tt-metal/runtime/sfpi"

      cp ${tt-metal.cpm} $sourceRoot/third_party/tt-metal/src/tt-metal/cmake/CPM.cmake
      cp ${tt-metal.cpm} $sourceRoot/third_party/tt-metal/src/tt-metal/tt_metal/third_party/umd/cmake/CPM.cmake

      mkdir -p $sourceRoot/tools/explorer/model-explorer/src/
      cp -r ${
        fetchFromGitHub {
          owner = "tenstorrent";
          repo = "model-explorer";
          rev = "a8c2343ea437b045c7a4a59cd8c43d94940e484c";
          hash = "sha256-abYG8My1Tv/yIOpKklkgwbB77rGkcM25F5U4LGyjl2M=";
        }
      } $sourceRoot/tools/explorer/model-explorer/src/model-explorer
      chmod -R u+w $sourceRoot/tools/explorer/model-explorer/src/model-explorer

      # Tries calling pip in a way that breaks
      cat << EOF > $sourceRoot/runtime/tools/chisel/CMakeLists.txt
      add_custom_target(chisel COMMENT "python chisel package")
      add_custom_command(
        COMMAND echo
        TARGET chisel
      )
      EOF

      pushd $sourceRoot/third_party/tt-metal/src/tt-metal/
      ${tt-metal.postPatch}
      ${tt-metal.preConfigure}

      echo "find_package(FlatBuffers REQUIRED)" >> cmake/flatbuffers.cmake

      cp -r ${tt-metal}/include $OLDPWD/$sourceRoot/build/include
      chmod -R u+w $OLDPWD/$sourceRoot/build/include

      rm -rf $OLDPWD/$sourceRoot/build/include/spdlog
      rm -rf $OLDPWD/$sourceRoot/build/include/ttnn

      cp -r build/_deps/spdlog-src/include/spdlog $OLDPWD/$sourceRoot/build/include/spdlog
      cp build/_deps/reflect-src/reflect $OLDPWD/$sourceRoot/build/include/reflect

      # Collides with tt-metal's enchantum headers
      rm -rf build/_deps/enchantum-src/enchantum/include/

      # CMake decides to make these paths required and calls flatc from it
      # Why? I have no idea.

      mkdir -p build/tt_metal
      ln -s ${lib.getExe flatbuffers_24} build/tt_metal/flatc

      mkdir -p build/tt_metal/fabric
      ln -s ${lib.getExe flatbuffers_24} build/tt_metal/fabric/flatc

      mkdir -p build/tt_metal/impl
      ln -s ${lib.getExe flatbuffers_24} build/tt_metal/impl/flatc

      mkdir -p build/tt_metal/distributed
      ln -s ${lib.getExe flatbuffers_24} build/tt_metal/distributed/flatc

      mkdir -p build/_deps/protobuf-build
      cp ${protobuf_21}/lib/lib* build/_deps/protobuf-build

      mkdir -p build/ttnn
      ln -s ${lib.getExe flatbuffers_24} build/ttnn/flatc
      cp ${tt-metal}/lib/_ttnn* build/ttnn/

      cp ${tt-metal}/lib/libtt_metal* build/tt_metal/

      mkdir -p build/tt_metal/third_party/umd/device
      cp ${tt-metal}/lib/libdevice* build/tt_metal/third_party/umd/device/

      cp -r ${tt-metal}/lib build/lib
      chmod -R u+w build

      # For some reason, CMake wants to prefix things in the build directory
      # even if they live in the nix store.
      mkdir -p build/nix
      ln -s /nix/store build/nix/store
      popd
    '';

    preConfigure = ''
      # Something "env/activate" does and the CMake wants
      export TT_METAL_HOME=$(readlink -f ../$sourceRoot/third_party/tt-metal/src/tt-metal)

      # tt-mlir cannot find its own headers
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(readlink -f ../$sourceRoot/include) -I$(readlink -f ../$sourceRoot/build/include)"

      cmakeFlagsArray+=(
        -DMODEL_EXPLORER_SOURCE_DIR=$(readlink -f ../$sourceRoot/tools/explorer/model-explorer/src/model-explorer)
        -DMETAL_SOURCE_DIR=$(readlink -f ../$sourceRoot/third_party/tt-metal/src/tt-metal)
      )

      mkdir -p tools/tt-alchemist/python/tt_alchemist/lib
    '';

    postConfigure = ''
      for p in $(grep --only-matching -rE 'include[A-Za-z\/]+\/mlir-tblgen' build.ninja | sed 's/\/mlir-tblgen//'); do
        mkdir -p $p
        rm -rf $p/mlir-tblgen
        ln -s ${lib.getExe' llvmPackages.tblgen "mlir-tblgen"} $p/mlir-tblgen
      done

      ln -s ${lib.getExe' llvmPackages.tblgen "mlir-tblgen"} python/mlir-tblgen
      touch ../third_party/tt-metal/src/tt-metal/build/cmake_install.cmake
    '';

    nativeBuildInputs = [
      cmake
      ninja
      python-env
      llvmPackages.llvm.dev
      llvmPackages.tblgen
      sphinx
      doxygen
      graphviz
      flatbuffers_24
      git
      pkg-config
    ];

    buildInputs = [
      llvmPackages.llvm
      (llvmPackages.mlir.overrideAttrs (
        f: p: {
          patches = p.patches or [ ] ++ [
            (fetchpatch {
              url = "https://github.com/llvm/llvm-project/commit/9349484e8f4c306318f75862ed25be6ec4c30ab8.patch";
              stripLen = 1;
              hash = "sha256-Oun5kmDfDXncb4BU+bEMweL+0sQsx5TOldx1kqvPy+g=";
            })
          ];

          nativeBuildInputs = p.nativeBuildInputs or [ ] ++ [
            (python3.withPackages (
              pythonPackages: with pythonPackages; [
                pybind11
                nanobind
              ]
            ))
          ];

          cmakeFlags = p.cmakeFlags or [ ] ++ [
            (lib.cmakeBool "MLIR_ENABLE_BINDINGS_PYTHON" true)
            (lib.cmakeBool "MLIR_INCLUDE_TESTS" true)
          ];
        }
      ))
      gtest
      blas
      capstone
    ]
    ++ tt-metal.buildInputs;

    cmakeFlags = [
      (lib.cmakeFeature "TTMLIR_GIT_HASH" "57f4afd4a32f55150739546a9d6a3ff5cb0cc0d8")
      (lib.cmakeFeature "TTMLIR_VERSION_MAJOR" (lib.versions.major finalAttrs.version))
      (lib.cmakeFeature "TTMLIR_VERSION_MINOR" (lib.versions.minor finalAttrs.version))
      (lib.cmakeFeature "TTMLIR_VERSION_PATCH" (lib.versions.patch finalAttrs.version))
      (lib.cmakeBool "TTMLIR_ENABLE_RUNTIME" true)
      (lib.cmakeBool "TT_RUNTIME_ENABLE_TTNN" true)
      (lib.cmakeBool "TT_RUNTIME_ENABLE_TTMETAL" true)
      (lib.cmakeBool "TT_RUNTIME_ENABLE_PERF_TRACE" true)
      (lib.cmakeBool "TTMLIR_ENABLE_BINDINGS_PYTHON" true)
      (lib.cmakeFeature "METAL_CONFIG_ARGS" (
        lib.concatStringsSep ";" [
          (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
          (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES" true)
          (lib.cmakeFeature "VERSION_NUMERIC" tt-metal.version)
          (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
        ]
      ))
    ];

    NIX_CFLAGS_COMPILE = builtins.toString [
      "-I${lib.getDev llvmPackages.mlir}/include"
      "-Wno-error"
    ];

    ninjaFlags = [
      "all"
      "build-wheel-tt-alchemist"
      "ttrt"
      "chisel"
      "explorer"
    ];

    postInstall = ''
      find . -name '*.whl' -exec python -m installer --prefix $out {} \;

      cp ./runtime/python/_ttmlir_runtime.cpython-* $out/${python3.sitePackages}/ttrt/runtime/
      cp ./runtime/lib/lib* $out/lib

      rm -rf $out/src $out/python_packages
      mv $out/$out/lib/* $out/lib
      rm -rf $out/$out
    '';

    # tt-mlir uses a custom LLVM fork that is based on a stable version
    passthru.llvmPackages = llvmPackages_21.override rec {
      name = "llvm";
      version = "21.0.0-unstable-2025-06-30";
      gitRelease = {
        rev = "f8cb7987c64dcffb72414a40560055cb717dbf74";
        rev-version = version;
        sha256 = "sha256-USaI+viu/LbRSCq5rQe+ca6vnExLsRhWiFktO553dvk=";
      };
      officialRelease = null;
      buildLlvmTools = buildPackages.tt-mlir.passthru.llvmPackages.tools;
      targetLlvmLibraries =
        targetPackages.tt-mlir.passthru.llvmPackages.libraries or llvmPackages.libraries;
      targetLlvm = targetPackages.tt-mlir.passthru.llvmPackages.llvm or llvmPackages.llvm;
    };

    meta = {
      description = "Compiler project aimed at defining MLIR dialects to abstract compute on Tenstorrent AI accelerators";
      homepage = "https://github.com/tenstorrent/tt-mlir";
      maintainers = with lib.maintainers; [ RossComputerGuy ];
      license = with lib.licenses; [ asl20 ];
      platforms = lib.platforms.linux;
    };
  }
)
