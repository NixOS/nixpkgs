args: with args;
stdenv.mkDerivation rec {
  name = "raptor-1.4.21";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "db3172d6f3c432623ed87d7d609161973d2f7098e3d2233d0702fbcc22cfd8ca";
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
