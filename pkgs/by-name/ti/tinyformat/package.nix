{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation rec {
  pname = "tinyformat";
  version = "unstable-2023-11-22";

  src = fetchFromGitHub {
    owner = "c42f";
    repo = "tinyformat";
    rev = "aef402d85c1e8f9bf491b72570bfe8938ae26727";
    hash = "sha256-Ka7fp5ZviTMgCXHdS/OKq+P871iYqoDOsj8HtJGAU3Y=";
  };
  patches = [
    ./0001-cmake-unbreak-and-add-install-targets.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = with lib; {
    description = "Minimal, type safe printf replacement library for C";
    homepage = "https://github.com/c42f/tinyformat";
    license = licenses.boost;
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "tinyformat";
    platforms = platforms.all;
  };
}
