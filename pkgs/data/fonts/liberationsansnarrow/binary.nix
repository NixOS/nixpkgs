{ stdenv, fetchurl, liberationsansnarrow }:

stdenv.mkDerivation rec {
  version = "1.07.6";
  name = "liberationsansnarrow-${version}";
  src = fetchurl {
    url = https://github.com/liberationfonts/liberation-sans-narrow/files/2579431/liberation-narrow-fonts-ttf-1.07.6.tar.gz;
    sha256 = "18wya6l20zfjhd96xrikjfz4p58bbhdc7vr8zk4hddgpbydxhyc8";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $(find . -name '*Narrow*.ttf') $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}" || true
  '';

  inherit (liberationsansnarrow) meta;
}
