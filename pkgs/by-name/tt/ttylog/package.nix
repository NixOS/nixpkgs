{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ttylog";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "rocasa";
    repo = "ttylog";
    rev = finalAttrs.version;
    hash = "sha256-B1T+Ry97FS+Jk7eG2MK15Q6AAkSzO4Sy3ueoK+8y5DA=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://ttylog.sourceforge.net";
    description = "Simple serial port logger";
    longDescription = ''
      A serial port logger which can be used to print everything to stdout
      that comes from a serial device.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ttylog";
  };
})
