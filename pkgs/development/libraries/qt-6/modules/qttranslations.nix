{
  qtModule,
  pkgsBuildBuild,
  stdenv,
  lib,
  qttools,
  runCommand,
}:

let
  isCrossBuild = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  isMingwCross = isCrossBuild && stdenv.hostPlatform.isMinGW;
  qtHostPathForTranslations =
    runCommand "qt6-host-path-for-qttranslations"
      {
        nativeBuildInputs = [
          pkgsBuildBuild.qt6.qtbase
          pkgsBuildBuild.qt6.qttools
        ];
      }
      ''
        mkdir -p $out/lib/cmake
        ln -sfnT ${pkgsBuildBuild.qt6.qttools}/bin $out/bin
        ln -sfnT ${pkgsBuildBuild.qt6.qttools}/libexec $out/libexec
        ln -sfnT ${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6 $out/lib/cmake/Qt6
        ln -sfnT ${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6HostInfo $out/lib/cmake/Qt6HostInfo
        ln -sfnT ${pkgsBuildBuild.qt6.qttools}/lib/cmake/Qt6Tools $out/lib/cmake/Qt6Tools
        ln -sfnT ${pkgsBuildBuild.qt6.qttools}/lib/cmake/Qt6LinguistTools $out/lib/cmake/Qt6LinguistTools
      '';
in
qtModule {
  pname = "qttranslations";

  nativeBuildInputs = [ (if isCrossBuild then pkgsBuildBuild.qt6.qttools else qttools) ];

  cmakeFlags = lib.optionals isCrossBuild [
    "-DQT_HOST_PATH=${qtHostPathForTranslations}"
    "-DQt6HostInfo_DIR=${qtHostPathForTranslations}/lib/cmake/Qt6HostInfo"
    "-DQT_OPTIONAL_TOOLS_PATH=${qtHostPathForTranslations}"
    "-DQt6LinguistTools_DIR=${qtHostPathForTranslations}/lib/cmake/Qt6LinguistTools"
  ];

  # MinGW cross: upstream's install logic ends up producing relative "nix/store/..." paths
  # inside the build tree, and then attempts to `cmake --install` into the output path,
  # which can fail with confusing "Permission denied" errors. The translations are
  # architecture-independent, so just copy the generated `.qm` files directly.
  installPhase = lib.optionalString isMingwCross ''
    runHook preInstall
    mkdir -p $out/translations
    find . -type f -name '*.qm' -path '*/translations/*' -print0 \
      | xargs -0 -I{} install -m644 {} $out/translations/
    runHook postInstall
  '';

  dontUseCmakeInstall = isMingwCross;
  separateDebugInfo = false;
  outputs = [ "out" ];
  allowedReferences = [ "out" ];
}
