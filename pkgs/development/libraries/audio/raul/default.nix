{ stdenv, fetchgit, boost, gtk2, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "raul-unstable-${rev}";
  rev = "2016-09-20";

  src = fetchgit {
    url = "http://git.drobilla.net/cgit.cgi/raul.git";
    rev = "f8bf77d3c3b77830aedafb9ebb5cdadfea7ed07a";
    sha256 = "1lby508fb0n8ks6iz959sh18fc37br39d6pbapwvbcw5nckdrxwj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost gtk2 python ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    description = "A C++ utility library primarily aimed at audio/musical applications";
    homepage = http://drobilla.net/software/raul;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
