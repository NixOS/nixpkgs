{stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, libtool, python2Packages, glib, jansson}:

stdenv.mkDerivation rec {
  version = "3.0.8";
  name = "libsearpc-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    # Tag is missing: https://github.com/haiwen/libsearpc/commit/12a01268825e9c7e17794c58c367e3b4db912ad9
    rev = "12a01268825e9c7e17794c58c367e3b4db912ad9";
    sha256 = "00ck1hl1x0pn22q3ba32dq3ckc4nrsg58irsmrnmalqbsffhcim0";
  };

  patches = [ ./libsearpc.pc.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool python2Packages.python python2Packages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  postPatch = "patchShebangs autogen.sh";

  preConfigure = "./autogen.sh";

  buildPhase = "make -j1";

  meta = {
    homepage = https://github.com/haiwen/libsearpc;
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
