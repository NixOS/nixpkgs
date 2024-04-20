{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-33oNUvLofFuM5QyRk+Jc6Q7vvWk68c/QqX0oiELoUrw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    homepage = "https://github.com/Tessil/robin-map";
    changelog = "https://github.com/Tessil/robin-map/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
