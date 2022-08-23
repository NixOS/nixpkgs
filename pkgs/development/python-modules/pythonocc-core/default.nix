{ lib, stdenv, python, fetchFromGitHub
, cmake
, Cocoa
, fontconfig
, freetype
, libGL
, libGLU
, libX11
, libXext
, libXi
, libXmu
, opencascade-occt
, rapidjson
, smesh
, swig
}:

stdenv.mkDerivation rec {
  pname = "pythonocc-core";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    rev = version;
    sha256 = "1md6x60pnfq0qv4lsnmjv6i96mzdrcpxcgpb316i7wmv9b5ci01s";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace "/usr/X11R6/lib/libGL.dylib" "${libGL}/lib/libGL.dylib" \
    --replace "/usr/X11R6/lib/libGLU.dylib" "${libGLU}/lib/libGLU.dylib"
  '';

  nativeBuildInputs = [ cmake swig ];
  buildInputs = [
    python opencascade-occt smesh
    freetype libGL libGLU libX11 libXext libXmu libXi
    fontconfig rapidjson
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
