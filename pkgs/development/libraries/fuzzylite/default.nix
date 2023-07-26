{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, useFloat ? false
}:

stdenv.mkDerivation rec {
  pname = "fuzzylite";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "fuzzylite";
    repo = "fuzzylite";
    rev = "v${version}";
    hash = "sha256-i1txeUE/ZSRggwLDtpS8dd4uuZfHX9w3zRH0gBgGXnk=";
  };
  sourceRoot = "${src.name}/fuzzylite";

  outputs = [ "out" "dev" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-Werror" "-Wno-error"
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DFL_BUILD_TESTS:BOOL=OFF"
    "-DFL_USE_FLOAT:BOOL=${if useFloat then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "A fuzzy logic control library in C++";
    homepage = "https://fuzzylite.com";
    changelog = "https://github.com/fuzzylite/fuzzylite/${src.rev}/release/CHANGELOG";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
