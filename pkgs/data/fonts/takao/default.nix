{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "takao";
  version = "00303.01";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/f/fonts-${pname}/fonts-${pname}_${version}.orig.tar.gz";
    hash = "sha256-0wjHNv1yStp0q9D0WfwjgUYoUKcCrXA5jFO8PEVgq5k=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Japanese TrueType Gothic, P Gothic, Mincho, P Mincho fonts";
    homepage = "https://launchpad.net/takao-fonts";
    license = licenses.ipa;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
