{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, ninja
, zeromq
, catch2
}:

stdenv.mkDerivation {
  pname = "azmq";
  version = "unstable-2023-03-23";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "azmq";
    rev = "2c1adac46bced4eb74ed9be7c74563bb113eaacf";
    hash = "sha256-4o1CHlg9kociIL6QN/kU2cojPvFRhtjFmKIAz0dapUM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    boost
    catch2
    zeromq
  ];

  # Broken for some reason on this platform.
  doCheck = !(stdenv.isAarch64 && stdenv.isLinux);

  meta = with lib; {
    homepage = "https://github.com/zeromq/azmq";
    license = licenses.boost;
    description = "C++ language binding library integrating ZeroMQ with Boost Asio";
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
