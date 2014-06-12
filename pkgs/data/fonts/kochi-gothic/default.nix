{ stdenv, fetchurl, dpkg }:

let version = "20030809";
in
stdenv.mkDerivation {
  name = "kochi-gothic-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/ttf-kochi/ttf-kochi-gothic_${version}-15_all.deb";
    sha256 = "6e2311cd8e880a9328e4d3eef34a1c1f024fc87fba0dce177a0e1584a7360fea";
  };

  buildInputs = [ dpkg ];

  unpackCmd = ''
    dpkg-deb --fsys-tarfile $src | tar xf - ./usr/share/fonts/truetype/kochi/kochi-gothic-subst.ttf
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp ./share/fonts/truetype/kochi/kochi-gothic-subst.ttf $out/share/fonts/truetype/
  '';

  meta = {
    description = "Japanese font, a free replacement for MS Gothic.";
    longDescription = ''
      Kochi Gothic was developed as a free replacement for the MS Gothic 
      font from Microsoft. This is the Debian version of Kochi Gothic, which
      removes some non-free glyphs that were added from the naga10 font.
    '';
    homepage = http://sourceforge.jp/projects/efont/;
    license = stdenv.lib.licenses.wadalab;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
