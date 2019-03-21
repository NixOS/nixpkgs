{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, zeromq3, jdk }:

stdenv.mkDerivation rec {
  name = "jzmq-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "jzmq";
    rev = "v${version}";
    sha256 = "1wlzs604mgmqmrgpk4pljx2nrlxzdfi3r8k59qlm90fx8qkqkc63";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zeromq3 jdk ];

  preConfigure = ''
    ${if stdenv.hostPlatform.system == "x86_64-darwin" then
      '' sed -i -e 's~/Headers~/include~' -e 's~_JNI_INC_SUBDIRS=\".*\"~_JNI_INC_SUBDIRS=\"darwin\"~' configure
      '' else ""}
  '';

  meta = {
    homepage = http://www.zeromq.org;
    description = "Java bindings for ZeroMQ";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.vizanto ];
  };
}
