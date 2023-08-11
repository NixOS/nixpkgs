{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation rec {
  pname = "frozen";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = version;
    hash = "sha256-HebDTRg1+snUwu+KumrgNMt/GOWXdHM9pMgXi51eArk=";
  };

  patches = [
    # Version 1.1.1 fails to build with gcc
    ./01-fix-gcc-build.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/serge-sans-paille/frozen";
    description = "a header-only, constexpr alternative to gperf for C++14 users";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
