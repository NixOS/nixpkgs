{stdenv, fetchgit, automake, autoconf, libtool, pkgconfig, zeromq2, jdk}:

stdenv.mkDerivation rec {
  name = "jzmq-2.1.0";

  src = fetchgit {
    url = git://github.com/zeromq/jzmq.git;
    rev = "946fd39780423b2df6e5efd9fa2cd863fd79c9db";
    sha256 = "0j6kfmngqw2gpyxc1ak67d65l208vrb0h8bm8svclia8b339m37a";
  };

  buildInputs = [ automake autoconf libtool pkgconfig zeromq2 jdk ];

  preConfigurePhases = ["./autogen.sh"];
  preConfigure = ''
    sed -i -e 's|(JAVAC)|(JAVAC) -encoding utf8|' src/Makefile.in
    ${if stdenv.system == "x86_64-darwin" then
      '' sed -i -e 's~/Headers~/include~' -e 's~_JNI_INC_SUBDIRS=\".*\"~_JNI_INC_SUBDIRS=\"darwin\"~' configure
      '' else ""}
  '';


  maintainers = [ stdenv.lib.maintainers.vizanto ];
  meta = {
    homepage = "http://www.zeromq.org";
    description = "Java bindings for ZeroMQ";
  };
}
