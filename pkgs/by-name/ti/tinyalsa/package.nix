{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "tinyalsa";
  version = "unstable-2022-06-05";

  src = fetchFromGitHub {
    owner = "tinyalsa";
    repo = "tinyalsa";
    rev = "3d70d227e7dfd1be6f8f420a5aae164a2b4126e0";
    hash = "sha256-RHeF3VShy+LYFtJK+AEU7swIr5/rnpg2fdllnH9cFCk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DTINYALSA_USES_PLUGINS=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=sign-compare"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    homepage = "https://github.com/tinyalsa/tinyalsa";
    description = "Tiny library to interface with ALSA in the Linux kernel";
    license = licenses.mit;
    maintainers = [ ];
    platforms = with platforms; linux;
  };
}
