{ stdenv, fetchurl, zlib, curl, expat, fuse, openssl }:

stdenv.mkDerivation rec {
  name = "afflib-3.6.12";

  src = fetchurl {
    url = "http://digitalcorpora.org/downloads/afflib/${name}.tar.gz";
    sha256 = "1l13nrqjlvad112543qbyvrzai5by43zl96d3miklrhn26q9rs07";
  };

  buildInputs = [ zlib curl expat fuse openssl ];

  meta = {
    homepage = http://afflib.sourceforge.net/;
    description = "Advanced forensic format library";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
