{ stdenv, fetchgit, gtk2, libsndfile, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lv2-unstable-${version}";
  version = "2016-10-23";

  src = fetchgit {
    url = "http://lv2plug.in/git/cgit.cgi/lv2.git";
    rev = "b36868f3b96a436961c0c51b5b2dd71d05da9b12";
    sha256 = "1sx39j0gary2nayzv7xgqcra7z1rcw9hrafkji05aksdwf7q0pdm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 libsndfile python ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://lv2plug.in;
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
