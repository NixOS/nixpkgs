{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tinyxml-2";
  version = "9.0.0";

  src = fetchFromGitHub {
    repo = "tinyxml2";
    owner = "leethomason";
    rev = version;
    sha256 = "sha256-AQQOctXi7sWIH/VOeSUClX6hlm1raEQUOp+VoPjLM14=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    description = "A simple, small, efficient, C++ XML parser";
    homepage = "https://www.grinninglizard.com/tinyxml2/index.html";
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
}
