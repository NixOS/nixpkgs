{ stdenv, fetchFromGitHub, cmake, zeromq }:

stdenv.mkDerivation rec {
  name = "cppzmq-${version}";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "v${version}";
    sha256 = "1yjs25ra5s8zs0rhk50w3f1rrrl80hhq784lwdhh1m3risk740sa";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
