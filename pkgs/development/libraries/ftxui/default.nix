{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "ftxui";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    rev = "v${version}";
    hash = "sha256-3kAhHDUwzwdvHc8JZAcA14tGqa6w69qrN1JXhSxNBQY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DFTXUI_BUILD_EXAMPLES=OFF"
    "-DFTXUI_BUILD_DOCS=OFF"
  ];

  # gtest and gbenchmark don't seem to generate any binaries
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
