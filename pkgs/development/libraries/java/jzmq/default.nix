{stdenv, fetchgit, automake, autoconf, libtool, pkgconfig, zeromq2, jdk}:

stdenv.mkDerivation rec {
  name = "jzmq-2.1.0";

  src = fetchgit {
    url = git://github.com/zeromq/jzmq.git;
    rev = "946fd39780423b2df6e5efd9fa2cd863fd79c9db";
  };

  buildInputs = [ automake autoconf libtool pkgconfig zeromq2 jdk ];

  preConfigurePhases = ["./autogen.sh"];
  preConfigure = if stdenv.system == "x86_64-darwin" then ''
    sed -i -e 's~/Headers~/include~' -e 's~_JNI_INC_SUBDIRS=\".*\"~_JNI_INC_SUBDIRS=\"darwin\"~' configure
  '' else "";


  maintainers = [ stdenv.lib.maintainers.blue ];
  meta = {
    homepage = "http://www.zeromq.org";
    description = "Java bindings for ZeroMQ";
  };
}
