{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
}:

stdenv.mkDerivation rec {
  pname = "ftxui";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2pCk4drYIprUKcjnrlX6WzPted7MUAp973EmAQX3RIE=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
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
