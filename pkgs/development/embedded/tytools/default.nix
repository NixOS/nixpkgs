{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "tytools";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "Koromix";
    repo = "rygel";
    tag = "tytools/${version}";
    hash = "sha256-nQZaNYOTkx79UC0RHencKIQFSYUnQ9resdmmWTmgQxA=";
  };

  nativeBuildInputs = [
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  buildPhase = ''
    runHook preBuild

    ./bootstrap.sh
    ./felix -p Fast tyuploader
    ./felix -p Fast tycmd
    ./felix -p Fast tycommander

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications
    cp bin/Fast/tyuploader $out/bin/
    cp bin/Fast/tycmd $out/bin/
    cp bin/Fast/tycommander $out/bin/
    cp src/tytools/tycommander/tycommander_linux.desktop $out/share/applications/tycommander.desktop
    cp src/tytools/tyuploader/tyuploader_linux.desktop $out/share/applications/tyuploader.desktop

    runHook postInstall
  '';

  meta = {
    description = "Collection of tools to manage Teensy boards";
    homepage = "https://koromix.dev/tytools";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ahuzik ];
  };
}
