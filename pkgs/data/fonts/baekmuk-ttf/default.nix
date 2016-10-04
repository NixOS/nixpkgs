{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "baekmuk-ttf-2.2";

  src = fetchurl {
    url = "http://kldp.net/baekmuk/release/865-${name}.tar.gz";
    sha256 = "10hqspl70h141ywz1smlzdanlx9vwgsp1qrcjk68fn2xnpzpvaq8";
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

