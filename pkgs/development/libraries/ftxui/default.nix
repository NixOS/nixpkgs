{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, cmake
, doxygen
, gbenchmark
, graphviz
, gtest
=======
, fetchpatch
, cmake
, doxygen
, graphviz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "ftxui";
<<<<<<< HEAD
  version = "5.0.0";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-IF6G4wwQDksjK8nJxxAnxuCw2z2qvggCmRJ2rbg00+E=";
  };

  strictDeps = true;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

<<<<<<< HEAD
  checkInputs = [
    gtest
    gbenchmark
  ];

  cmakeFlags = [
    "-DFTXUI_BUILD_EXAMPLES=OFF"
    "-DFTXUI_BUILD_DOCS=ON"
    "-DFTXUI_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
=======
  cmakeFlags = [
    "-DFTXUI_BUILD_EXAMPLES=OFF"
  ];

  # gtest and gbenchmark don't seem to generate any binaries
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
<<<<<<< HEAD
    platforms = platforms.all;
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
