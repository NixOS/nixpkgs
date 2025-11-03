{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teensy-cmake-macros";
  version = "0-unstable-2023-04-15";

  src = fetchFromGitHub {
    owner = "newdigate";
    repo = "teensy-cmake-macros";
    rev = "dc401ed23e6e13a9db3cd2a65f611a4738df3b0e";
    hash = "sha256-E+BOlsCJtOScr3B5GSv1WM6rFv6cFYvm/iJ893fsmXM=";
  };

  propagatedBuildInputs = [
    cmake
    pkg-config
  ];

  passthru = {
    hook = callPackage ./hook.nix {
      teensy-cmake-macros = finalAttrs.finalPackage;
    };
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "CMake macros for building teensy projects";
    platforms = platforms.all;
    homepage = "https://github.com/newdigate/teensy-cmake-macros";
    license = licenses.mit;
    maintainers = [ maintainers.michaeldonovan ];
  };
})
