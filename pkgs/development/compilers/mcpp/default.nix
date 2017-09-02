{ stdenv, fetchurl, mcpp }:

stdenv.mkDerivation rec {
  name = "mcpp-2.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/mcpp/${name}.tar.gz";
    sha256 = "0r48rfghjm90pkdyr4khxg783g9v98rdx2n69xn8f6c5i0hl96rv";
  };

  configureFlags = [ "--enable-mcpplib" ];

  meta = with stdenv.lib; {
    homepage = http://mcpp.sourceforge.net/;
    description = "A portable c preprocessor";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
