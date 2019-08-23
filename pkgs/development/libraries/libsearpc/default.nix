{stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, libtool, python2Packages, glib, jansson}:

stdenv.mkDerivation rec {
  version = "3.1.0";
  name = "libsearpc-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    rev = "v${version}";
    sha256 = "1zf8xxsl95wdx0372kl8s153hd8q3lhwwvwr2k96ia8scbn2ylkp";
  };

  patches = [ ./libsearpc.pc.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool python2Packages.python python2Packages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  postPatch = "patchShebangs autogen.sh";

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/libsearpc;
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
