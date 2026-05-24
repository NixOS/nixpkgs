{
  lib,
  stdenv,
  fetchFromGitHub,
  kdePackages,
}:

stdenv.mkDerivation {
  pname = "utterly-nord-plasma";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "HimDek";
    repo = "utterly-nord-plasma";
    rev = "ae0de9d555b518226627b2d10ee5df4a18073c60";
    hash = "sha256-lXX7Gk2QYyMP96qbYdHtommW0DM1DUK03cti1gAeBBc=";
  };

  dontWrapQtApps = true;

  propagatedBuildInputs = with kdePackages; [
    # avoid .dev outputs propagation
    qt5compat.out
    kirigami
    libplasma.out
    plasma5support.out
    plasma-workspace.out
    ksvg.out
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{color-schemes,Kvantum,plasma/look-and-feel,sddm/themes,wallpapers,konsole}

    cp -a look-and-feel $out/share/plasma/look-and-feel/Utterly-Nord
    cp -a look-and-feel-solid $out/share/plasma/look-and-feel/Utterly-Nord-Solid
    cp -a look-and-feel-light $out/share/plasma/look-and-feel/Utterly-Nord-Light
    cp -a look-and-feel-light-solid $out/share/plasma/look-and-feel/Utterly-Nord-Light-Solid

    cp -a *.colors $out/share/color-schemes/

    cp -a wallpaper $out/share/wallpapers/Utterly-Nord

    cp -a kvantum $out/share/Kvantum/Utterly-Nord
    cp -a kvantum-solid $out/share/Kvantum/Utterly-Nord-Solid
    cp -a kvantum-light $out/share/Kvantum/Utterly-Nord-Light
    cp -a kvantum-light-solid $out/share/Kvantum/Utterly-Nord-Light-Solid

    cp -a *.colorscheme $out/share/konsole/

    cp -a sddm $out/share/sddm/themes/Utterly-Nord

    runHook postInstall
  '';

  meta = {
    description = "Plasma theme with Nordic Colors, transparency, blur and round edges for UI elements";
    homepage = "https://himdek.com/Utterly-Nord-Plasma/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
