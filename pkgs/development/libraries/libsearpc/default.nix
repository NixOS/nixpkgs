{stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, libtool, python2Packages, glib, jansson}:

stdenv.mkDerivation rec {
  version = "3.2.0";
  pname = "libsearpc";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    rev = "v${version}";
    sha256 = "18i5zvrp6dv6vygxx5nc93mai2p2x786n5lnf5avrin6xiz2j6hd";
  };

  patches = [ ./libsearpc.pc.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool python2Packages.python python2Packages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  postPatch = "patchShebangs autogen.sh";

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
