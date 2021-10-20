{ lib, stdenv, python, fetchFromGitHub, cmake, swig, ninja
, opencascade, smesh, freetype, libGL, libGLU, libX11
, Cocoa }:

stdenv.mkDerivation rec {
  pname = "pythonocc-core";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    rev = version;
    sha256 = "1jk4y7f75z9lyawffpfkr50qw5452xzi1imcdlw9pdvf4i0y86k3";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace "/usr/X11R6/lib/libGL.dylib" "${libGL}/lib/libGL.dylib" \
    --replace "/usr/X11R6/lib/libGLU.dylib" "${libGLU}/lib/libGLU.dylib"
  '';

  nativeBuildInputs = [ cmake swig ];
  buildInputs = [
    python opencascade smesh
    freetype libGL libGLU libX11
  ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  cmakeFlags = [
    "-Wno-dev"
    "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"

    "-DSMESH_INCLUDE_PATH=${smesh}/include/smesh"
    "-DSMESH_LIB_PATH=${smesh}/lib"
    "-DPYTHONOCC_WRAP_SMESH=TRUE"
  ];

  meta = with lib; {
    description = "Python wrapper for the OpenCASCADE 3D modeling kernel";
    homepage = "https://github.com/tpaviot/pythonocc-core";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
