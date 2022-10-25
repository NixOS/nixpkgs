{ lib
, buildPythonPackage
, fetchFromGitHub
, boost
, cgal_5
, cmake
, eigen
, gmp
, mpfr
, numpy
, pytestCheckHook
, swig
, zlib
}:

buildPythonPackage rec {
  pname = "cgal-swig-bindings";
  version = "unstable-2022-03-28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "cgal-swig-bindings";
    rev = "422c3e2a3230e478dd609e1dc44d6529e2bc963d";
    hash = "sha256-OBPm/VCeqGskmpkgaYWHuGhaDycOOTyWDhPt1Bi8Zns=";
  };

  nativeBuildInputs = [
    cmake
    numpy
    swig
  ];
  buildInputs = [
    boost
    cgal_5
    eigen
    gmp
    mpfr
    zlib
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "CGAL.CGAL_Kernel"
    "CGAL.CGAL_Triangulation_3"
  ];
  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "CGAL bindings using SWIG";
    homepage = "https://github.com/CGAL/cgal-swig-bindings";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veprbl ];
  };
}
