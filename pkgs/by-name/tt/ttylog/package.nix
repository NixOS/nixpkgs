{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "ttylog";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "rocasa";
    repo = "ttylog";
    rev = version;
    sha256 = "0c746bpjpa77vsr88fxk8h1803p5np1di1mpjf4jy5bv5x3zwm07";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    homepage = "https://ttylog.sourceforge.net";
    description = "Simple serial port logger";
    longDescription = ''
      A serial port logger which can be used to print everything to stdout
      that comes from a serial device.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "ttylog";
  };
}
