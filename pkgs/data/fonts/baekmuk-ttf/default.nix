{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "baekmuk-ttf-2.2";

  src = fetchurl {
    url = "http://kldp.net/frs/download.php/1429/${name}.tar.gz";
    sha256 = "08ab7dffb55d5887cc942ce370f5e33b756a55fbb4eaf0b90f244070e8d51882";
  };

  dontBuild = true;

  installPhase = let
    fonts_dir = "$out/share/fonts";
    doc_dir = "$out/share/doc/${name}";
  in ''
    mkdir -pv ${fonts_dir}
    mkdir -pv ${doc_dir}
    cp ttf/*.ttf ${fonts_dir}
    cp COPYRIGHT* ${doc_dir}
  '';

  meta = {
    description = "Korean font";
    homepage = "http://kldp.net/projects/baekmuk/";
    license = "BSD-like";
    platforms = stdenv.lib.platforms.linux;
  };
}

