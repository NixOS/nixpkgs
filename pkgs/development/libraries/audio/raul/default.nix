{ stdenv, fetchgit, boost, gtk2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "raul-unstable-${rev}";
  rev = "2017-07-23";

  src = fetchgit {
    url = "http://git.drobilla.net/cgit.cgi/raul.git";
    rev = "4db870b2b20b0a608ec0283139056b836c5b1624";
    sha256 = "04fajrass3ymr72flx5js5vxc601ccrmx8ny8scp0rw7j0igyjdr";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ boost gtk2 python ];

  meta = with stdenv.lib; {
    description = "A C++ utility library primarily aimed at audio/musical applications";
    homepage = http://drobilla.net/software/raul;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
