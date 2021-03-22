{ stdenv, fetchFromGitHub, cmake, pkgconfig, zeromq, libsodium }:

stdenv.mkDerivation rec {
  pname = "loki-mq";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "loki-project";
    repo = "loki-mq";
    rev = "v${version}";
    sha256 = "0av1nv6c6vvs9sxyabwb1yhfv8s2myrnhzdlqjw6nf2c0x3bj4x9";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ zeromq libsodium ];

  meta = with stdenv.lib; {
    description = "Zeromq-based message passing for Loki projects";
    homepage = "https://github.com/loki-project/loki-mq";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chiiruno ];
  };
}
