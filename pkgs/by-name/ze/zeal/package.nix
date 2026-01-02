{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  httplib,
  libarchive,
  libXdmcp,
  libpthreadstubs,
  xcbutilkeysyms,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zeal";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9tlo7+namWNWrWVQNqaOvtK4NQIdb0p8qvFrrbUamOo=";
  };

  patches = [ ./qt6_10.patch ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    httplib
    libXdmcp
    libarchive
    libpthreadstubs
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtwebengine
    xcbutilkeysyms
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
