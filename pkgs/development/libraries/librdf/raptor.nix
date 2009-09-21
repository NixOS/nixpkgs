args: with args;
stdenv.mkDerivation {
  name = "raptor-1.4.19";

  src = fetchurl {
    url = http://download.librdf.org/source/raptor-1.4.19.tar.gz;
    sha256 = "0qpfl73dvkhngica7wk9qglvd0b3fp9wqnjkl5q8m6h1kf8605ml";
  };

  buildInputs = [
    #optional
    libxml2 curl];

  meta = { 
    description = "The RDF Parser Toolkit";
    homepage = "http://librdf.org/raptor";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
