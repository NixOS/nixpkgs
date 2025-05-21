{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "utterly-round-plasma-style";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "HimDek";
    repo = "utterly-round-plasma-style";
    rev = "6280f69781b7fa9613b7a9c502d8d61e11fefca5";
    hash = "sha256-b0vah/rkcJH01bnDOGXQ04vrRR1c1Ijgc2HPBmToLuc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{aurorae/themes,plasma/desktoptheme}

    cp -a aurorae/dark/translucent $out/share/aurorae/themes/Utterly-Round-Dark
    cp -a aurorae/dark/solid $out/share/aurorae/themes/Utterly-Round-Dark-Solid
    cp -a aurorae/light/translucent $out/share/aurorae/themes/Utterly-Round-Light
    cp -a aurorae/light/solid $out/share/aurorae/themes/Utterly-Round-Light-Solid

    cp -a desktoptheme/translucent $out/share/plasma/desktoptheme/Utterly-Round
    cp -a desktoptheme/solid $out/share/plasma/desktoptheme/Utterly-Round-Solid

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rounded desktop theme and window borders for Plasma 5 that follows any color scheme";
    homepage = "https://himdek.com/Utterly-Round-Plasma-Style/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
