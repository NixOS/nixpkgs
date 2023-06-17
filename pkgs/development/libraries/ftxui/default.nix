{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, gbenchmark
, graphviz
, gtest
}:

stdenv.mkDerivation rec {
  pname = "ftxui";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    rev = "v${version}";
    sha256 = "sha256-qFgCLV7sgGxlL18sThqpl+vyXL68GXcbYqMG7mXhsB4=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  nativeCheckInputs = [
    gbenchmark
    gtest
  ];

  cmakeFlags = [
    "-DFTXUI_BUILD_EXAMPLES=OFF"
    "-DFTXUI_BUILD_DOCS=ON"
    "-DFTXUI_BUILD_TESTS=ON"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.all;
  };
}
