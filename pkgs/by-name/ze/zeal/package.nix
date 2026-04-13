{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  httplib,
  libarchive,
  libxdmcp,
  libpthread-stubs,
  libxcb-keysyms,
  qt6,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zeal";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FGg89bluN2IJJtkjwPa6dC83CBLdOr+LW5ArUKp4awk=";
  };

  patches = [
    # https://github.com/zealdocs/zeal/issues/1813
    # Can likely remove with 0.9
    (fetchpatch {
      name = "fix-activateShortcut-protected.patch";
      url = "https://github.com/zealdocs/zeal/commit/f3714111ecad65ddedde43fc7c4f8c5bd240ff64.patch";
      hash = "sha256-DKTvanO14NRFhiHayJIWXWO7gQSRyjCQ1XFAiEN86XI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    httplib
    libxdmcp
    libarchive
    libpthread-stubs
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtwebengine
    libxcb-keysyms
  ];

  cmakeFlags = [
    (lib.cmakeBool "ZEAL_RELEASE_BUILD" true)
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r Zeal.app $out/Applications
    ln -s $out/Applications/Zeal.app/Contents/MacOS/Zeal $out/bin/zeal

    runHook postInstall
  '';

  meta = {
    description = "Simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
    changelog = "https://github.com/zealdocs/zeal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    mainProgram = "zeal";
    inherit (qt6.qtbase.meta) platforms;
  };
})
