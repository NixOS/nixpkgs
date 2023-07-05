{ lib, stdenv, fetchFromGitHub, unzip, cmake, freeglut, libGLU, libGL, zlib, swig, doxygen, xorg, python3 }:

stdenv.mkDerivation rec {
  pname = "partio";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    rev = "refs/tags/v${version}";
    hash = "sha256-QKGZ9oR5M39LS7insiRfXtp/+kQtFL+zM2X73JCX5Ms=";
  };

  outputs = [ "dev" "out" "lib" ];

  nativeBuildInputs = [ unzip cmake doxygen ];
  buildInputs = [ freeglut libGLU libGL zlib swig xorg.libXi xorg.libXmu python3 ];

  # TODO:
  # Sexpr support

  strictDeps = true;

  meta = with lib; {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
    homepage = "https://www.disneyanimation.com/technology/partio.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.guibou ];
  };
}
