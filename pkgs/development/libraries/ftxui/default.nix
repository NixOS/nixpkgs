{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, doxygen
, graphviz
}:

stdenv.mkDerivation rec {
  pname = "ftxui";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    rev = "v${version}";
    sha256 = "sha256-2pCk4drYIprUKcjnrlX6WzPted7MUAp973EmAQX3RIE=";
  };

  patches = [
    # Can be removed once https://github.com/ArthurSonzogni/FTXUI/pull/403 hits a stable release
    (fetchpatch {
      name = "fix-postevent-segfault.patch";
      url = "https://github.com/ArthurSonzogni/FTXUI/commit/f9256fa132e9d3c50ef1e1eafe2774160b38e063.patch";
      sha256 = "sha256-0040/gJcCXzL92FQLhZ2dNMJhNqXXD+UHFv4Koc07K0=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  cmakeFlags = [
    "-DFTXUI_BUILD_EXAMPLES=OFF"
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
