{ lib, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libfrozen";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "refs/tags/${version}";
    sha256 = "sha256-HebDTRg1+snUwu+KumrgNMt/GOWXdHM9pMgXi51eArk=";
  };

  nativeBuildInputs = [ cmake  ];

  meta = with lib; {
    homepage = "https://github.com/serge-sans-paille/frozen";
    description = "A consteval containers library for C++";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ jstranik ];
  };
}
