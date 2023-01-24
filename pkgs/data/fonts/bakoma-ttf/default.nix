{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "bakoma-ttf";
  version = "2.2";

  src = fetchurl {
    name = "${pname}.tar.bz2";
    url = "http://tarballs.nixos.org/sha256/1j1y3cq6ys30m734axc0brdm2q9n2as4h32jws15r7w5fwr991km";
    hash = "sha256-dYaUMneFn1yC5lIMSLQSNmFRW16AdUXGqWBobzAbPsg=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp ttf/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "TrueType versions of the Computer Modern and AMS TeX Fonts";
    homepage = "http://www.ctan.org/tex-archive/fonts/cm/ps-type1/bakoma/ttf/";
  };
}
