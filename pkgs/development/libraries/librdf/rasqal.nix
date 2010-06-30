args: with args;
stdenv.mkDerivation {
  name = "rasqal-0.9.16";

  src = fetchurl {
    url = http://download.librdf.org/source/rasqal-0.9.16.tar.gz;
    sha256 = "1qvxbkynxwfw22hn2qbgxczzaq24h9649bcfbc598x9gq5m7hsq6";
  };

  buildInputs = [
    librdf_raptor
    gmp /*or mpfr*/
    #optional
    pcre libxml2 
    ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lraptor"
  '';

  meta = { 
    description = "library that handles Resource Description Framework (RDF)";
    homepage = "http://librdf.org/rasqal";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
