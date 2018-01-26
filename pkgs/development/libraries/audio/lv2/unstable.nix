{ stdenv, fetchgit, gtk2, libsndfile, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lv2-unstable-${version}";
  version = "2017-07-08";

  src = fetchgit {
    url = "http://lv2plug.in/git/cgit.cgi/lv2.git";
    rev = "39c7c726cd52b2863fcea356cafe1bcab2ba7f37";
    sha256 = "1gp2rd99dfmpibvpixrqn115mrhybzf3if3h8bssf6siyi13f29r";
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
