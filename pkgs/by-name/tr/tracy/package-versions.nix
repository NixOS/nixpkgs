{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchurl,
  callPackage,

  coreutils,
  cmake,
  ninja,
  pkg-config,
  wayland-scanner,

  capstone,
  dbus,
  freetype,
  glfw,
  onetbb,

  withGtkFileSelector ? false,
  gtk3,

  withWayland ? stdenv.hostPlatform.isLinux,
  libglvnd,
  libxkbcommon,
  wayland,
  wayland-protocols,
  libffi,

  md4c,
  pugixml,
  curl,
  zstd,
  nlohmann_json,
  nativefiledialog-extended,
  html-tidy,
}:

assert withGtkFileSelector -> stdenv.hostPlatform.isLinux;

let
  mkTracyPackage =
    {
      version,
      srcHash,
      cpmSrcs ? [ ],
      patches ? [ ],
      extraBuildInputs ? [ ],
    }:
    stdenv.mkDerivation {
      inherit patches;

      pname = "tracy";
      inherit version;

      src = fetchFromGitHub {
        name = "tracy";
        owner = "wolfpld";
        repo = "tracy";
        rev = "v${version}";
        hash = "${srcHash}";
      };

      postUnpack = (
        lib.strings.concatLines (
          lib.lists.forEach cpmSrcs (
            s:
            # Make CPM sources writable for patches and set CPM_<package>_SOURCE flags
            ''
              cp -R ${s.out} ${s.name}
              chmod -R u+w ${s.name}
              appendToVar cmakeFlags -DCPM_${s.name}_SOURCE=$(pwd)/${s.name}
            ''

            # PPQSort tries to download CPM.cmake
            # Provide it the newer version from tracy instead
            + lib.optionalString (s.name == "PPQSort") ''
              cp ./tracy/cmake/CPM.cmake PPQSort/cmake/CPM.cmake
            ''
          )
        )
      );

      nativeBuildInputs = [
        cmake
        ninja
        pkg-config
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland-scanner ]
      ++ lib.optionals stdenv.cc.isClang [ stdenv.cc.cc.libllvm ];

      buildInputs = [
        freetype
        onetbb
      ]
      ++ extraBuildInputs
      ++ lib.optionals (stdenv.hostPlatform.isLinux && withGtkFileSelector) [ gtk3 ]
      ++ lib.optionals (stdenv.hostPlatform.isLinux && !withGtkFileSelector) [ dbus ]
      ++ lib.optionals (stdenv.hostPlatform.isLinux && withWayland) [
        libglvnd
        libxkbcommon
        wayland
        wayland-protocols
        libffi
      ]
      ++ lib.optionals (stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && !withWayland)) [
        glfw
      ];

      cmakeFlags = [
        (lib.cmakeBool "DOWNLOAD_CAPSTONE" false)
        (lib.cmakeBool "TRACY_STATIC" false)
        (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" true)
        (lib.cmakeBool "CPM_FIND_DEBUG_MODE" true)
        (lib.cmakeFeature "CMAKE_MODULE_PATH" "${./cmake}")
      ]
      ++ lib.optional (stdenv.hostPlatform.isLinux && withGtkFileSelector) (
        lib.cmakeBool "GTK_FILESELECTOR" true
      )
      ++ lib.optional (stdenv.hostPlatform.isLinux && !withWayland) (lib.cmakeBool "LEGACY" true)
      ++ lib.optional (stdenv.hostPlatform.isLinux && withWayland) (
        lib.cmakeFeature "CPM_wayland-protocols_SOURCE" "${wayland-protocols}/share/wayland-protocols"
      );

      env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-ltbb";

      dontUseCmakeBuildDir = true;

      postConfigure =
        # CPM_<package>_SOURCE flags prevent downloads but cause each of the sub-projects
        # to apply the same patches to the same source. The patch tool will return a
        # non-zero status, failing the build, even if configured to ignore patch re-application.
        #
        # The workaround is to first configure the profiler since it includes all of the
        # dependencies and then short-circuit the patch command for the remaining projects.
        ''
          cmake -B profiler/build -S profiler $cmakeFlags

          appendToVar cmakeFlags -DPATCH_EXECUTABLE=${coreutils}/bin/true

          cmake -B capture/build -S capture $cmakeFlags
          cmake -B csvexport/build -S csvexport $cmakeFlags
          cmake -B import/build -S import $cmakeFlags
          cmake -B update/build -S update $cmakeFlags
        '';

      postBuild = ''
        ninja -C capture/build
        ninja -C csvexport/build
        ninja -C import/build
        ninja -C profiler/build
        ninja -C update/build
      '';

      postInstall = ''
        install -D -m 0555 capture/build/tracy-capture -t $out/bin
        install -D -m 0555 csvexport/build/tracy-csvexport $out/bin
        install -D -m 0555 import/build/{tracy-import-chrome,tracy-import-fuchsia} -t $out/bin
        install -D -m 0555 profiler/build/tracy-profiler $out/bin/tracy
        install -D -m 0555 update/build/tracy-update -t $out/bin
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        substituteInPlace extra/desktop/tracy.desktop \
          --replace-fail Exec=/usr/bin/tracy Exec=tracy

        install -D -m 0444 extra/desktop/application-tracy.xml $out/share/mime/packages/application-tracy.xml
        install -D -m 0444 extra/desktop/tracy.desktop $out/share/applications/tracy.desktop
        install -D -m 0444 icon/application-tracy.svg $out/share/icons/hicolor/scalable/apps/application-tracy.svg
        install -D -m 0444 icon/icon.png $out/share/icons/hicolor/256x256/apps/tracy.png
        install -D -m 0444 icon/icon.svg $out/share/icons/hicolor/scalable/apps/tracy.svg
      '';

      meta = {
        description = "Real time, nanosecond resolution, remote telemetry frame profiler for games and other applications";
        homepage = "https://github.com/wolfpld/tracy";
        license = lib.licenses.bsd3;
        mainProgram = "tracy";
        maintainers = with lib.maintainers; [
          mpickering
          nagisa
        ];
        platforms = lib.platforms.linux ++ lib.optionals (!withWayland) lib.platforms.darwin;
      };
    };
in
rec {
  tracy_0_11 = mkTracyPackage (
    import ./tracy-0.11.nix {
      inherit
        lib
        stdenv
        capstone
        ;
    }
  );

  tracy_0_12 = mkTracyPackage (
    import ./tracy-0.12.nix {
      inherit
        fetchFromGitHub
        fetchFromGitLab
        zstd
        nativefiledialog-extended
        ;
    }
  );

  tracy_0_13 = mkTracyPackage (
    import ./tracy-0.13.nix {
      inherit
        fetchFromGitHub

        md4c
        pugixml
        curl
        zstd
        nlohmann_json
        nativefiledialog-extended
        html-tidy
        ;
    }
  );

  tracy_latest = tracy_0_13;
}
