{ stdenv, fetchurl, dpkg }:

let version = "20030809";
in
stdenv.mkDerivation {
  name = "kochi-mincho-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/ttf-kochi/ttf-kochi-mincho_${version}-15_all.deb";
    sha256 = "91ce6c993a3a0f77ed85db76f62ce18632b4c0cbd8f864676359a17ae5e6fa3c";
  };

  buildInputs = [ dpkg ];

  unpackCmd = ''
    dpkg-deb --fsys-tarfile $src | tar xf - ./usr/share/fonts/truetype/kochi/kochi-mincho-subst.ttf
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp ./share/fonts/truetype/kochi/kochi-mincho-subst.ttf $out/share/fonts/truetype/
  '';

  meta = {
    description = "Japanese font, a free replacement for MS Mincho.";
    longDescription = ''
      Kochi Mincho was developed as a free replacement for the MS Mincho 
      font from Microsoft. This is the Debian version of Kochi Mincho, which
      removes some non-free glyphs that were added from the naga10 font.
    '';
    homepage = http://sourceforge.jp/projects/efont/;
    license = stdenv.lib.licenses.wadalab;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
