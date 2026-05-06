{
  lib,
  stdenvNoCC,
  fetchzip,
  plasma5Packages,
}:

stdenvNoCC.mkDerivation {
  pname = "yet-another-monochrome-icon-set";
  version = "1.3.7";

  src = fetchzip {
    url = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set/get/82cc7fe71231d6dd48c8d497f76f41471fa47c20.zip";
    hash = "sha256-OBlREiChDzTyyrA+CjPmjvzypzHYbZK6vMFrgrBQdzE=";
    stripRoot = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    themeDir="$out/share/icons/yet-another-monochrome-icon-set"
    mkdir -p "$themeDir"
    cp -R ./* "$themeDir/"
    test -f "$themeDir/index.theme"
    runHook postInstall
  '';

  propagatedBuildInputs = [
    plasma5Packages.breeze-icons
  ];

  meta = {
    description = "Monochrome icon theme for KDE Plasma desktops";
    homepage = "https://store.kde.org/p/2303161";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.therealglh ];
  };
}
