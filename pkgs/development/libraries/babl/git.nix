{ stdenv, fetchgit, autoconf, automake, which, libtool }:

stdenv.mkDerivation rec {

  rev ="218970da446099fa4e35ea33c83608f77137c754";
  name = "babl-${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://git.gnome.org/babl";
    sha256 = "1b7xlp4b1mc3ndbixjm7m0pwmfdc6gfc0yswi9n839f4rj2cvgmw";
  };

  buildInputs = [ autoconf automake which libtool ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = stdenv.lib.licenses.gpl3;
    hydraPlatforms = [];
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
