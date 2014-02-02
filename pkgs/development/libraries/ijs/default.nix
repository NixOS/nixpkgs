{stdenv, fetchurl, ghostscript}:

stdenv.mkDerivation {
  name = "ijs-0.36";

  enableParallelBuilding = true;

  src = fetchurl {
    url = http://www.openprinting.org/download/ijs/download/ijs-0.35.tar.bz2;
    sha256 = "1ffaa1dnr99h2fjhn2pn5ckn9fs7f56xc92szzrq1i488h4gb98i";
  };

  buildInputs = [
    # only required for building pdf documentation ?
    # also requires db2ps ?
    # ghostscript
    ];

  meta = {
    description = "Library which implements a protocol for transmission of raster page images";
    homepage = http://www.openprinting.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
