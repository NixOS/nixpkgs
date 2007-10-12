args: with args;

stdenv.mkDerivation {
  name = "openexr-1.6.0";
  src = fetchurl {
    url = http://FIXME/openexr-1.6.0.tar.gz;
	sha256 = "0mzbwavkbj26g43ar5jhdrqlvw9nq1mxh9l2044sqlcyharcnfq4";
  };
  propagatedBuildInputs = [pkgconfig zlib ilmbase];
  configureFlags = "--enable-shared --disable-static --enable-imfexamples";
}
