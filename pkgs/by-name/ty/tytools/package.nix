{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tytools";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "Koromix";
    repo = "rygel";
    tag = "tytools/${finalAttrs.version}";
    hash = "sha256-nQZaNYOTkx79UC0RHencKIQFSYUnQ9resdmmWTmgQxA=";
  };

  nativeBuildInputs = [
    installShellFiles
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
  ];

  buildPhase = ''
    runHook preBuild

    ./bootstrap.sh
    ./felix -pFast tycmd tycommander tyuploader

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installBin bin/Fast/tycmd bin/Fast/tycommander bin/Fast/tyuploader
    install -D --mode 0644 src/tytools/tycommander/tycommander_linux.desktop $out/share/applications/tycommander.desktop
    install -D --mode 0644 src/tytools/tyuploader/tyuploader_linux.desktop $out/share/applications/tyuploader.desktop
    install -D --mode 0644 src/tytools/assets/images/tycommander.png $out/share/icons/hicolor/512x512/apps/tycommander.png
    install -D --mode 0644 src/tytools/assets/images/tyuploader.png $out/share/icons/hicolor/512x512/apps/tyuploader.png

    runHook postInstall
  '';

  meta = {
    description = "Collection of tools to manage Teensy boards";
    homepage = "https://koromix.dev/tytools";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ahuzik ];
  };
})
