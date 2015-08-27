{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "docbook-xsl-1.78.1";

  src = fetchurl {
    url = "mirror://sourceforge/docbook/${name}.tar.bz2";
    sha256 = "0rxl013ncmz1n6ymk2idvx3hix9pdabk8xn01cpcv32wmfb753y9";
  };

  buildPhase = "true";

  installPhase =
    ''
      dst=$out/share/xml/docbook-xsl
      mkdir -p $dst
      rm -rf RELEASE* README* INSTALL TODO NEWS* BUGS install.sh svn* tools log Makefile tests extensions webhelp
      mv * $dst/

      # Backwards compatibility. Will remove eventually.
      mkdir -p $out/xml/xsl
      ln -s $dst $out/xml/xsl/docbook
    '';
}
