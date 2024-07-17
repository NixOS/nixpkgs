{
  lib,
  stdenv,
  fetchFromGitHub,
  breeze-icons,
  kdeclarative,
  kirigami2,
  plasma-framework,
  plasma-workspace,
}:

stdenv.mkDerivation rec {
  pname = "utterly-nord-plasma";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "HimDek";
    repo = pname;
    rev = "6d9ffe008f0bee47c8346c9a7ec71f206d999fd0";
    hash = "sha256-B5pIwV0BHxDluKWKTy+xuBPaE3N6UOHXip1SIAm2kM8=";
  };

  propagatedUserEnvPkgs = [
    breeze-icons
    kdeclarative.bin
    kirigami2
    plasma-framework.bin
    plasma-workspace
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{color-schemes,Kvantum,plasma/look-and-feel,sddm/themes,wallpapers,konsole}

    cp -a look-and-feel $out/share/plasma/look-and-feel/Utterly-Nord
    cp -a look-and-feel-solid $out/share/plasma/look-and-feel/Utterly-Nord-solid
    cp -a look-and-feel-light $out/share/plasma/look-and-feel/Utterly-Nord-light
    cp -a look-and-feel-light-solid $out/share/plasma/look-and-feel/Utterly-Nord-light-solid

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

  meta = with lib; {
    description = "A Plasma theme with Nordic Colors, transparency, blur and round edges for UI elements";
    homepage = "https://himdek.com/Utterly-Nord-Plasma/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
