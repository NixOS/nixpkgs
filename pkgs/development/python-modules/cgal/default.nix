{ lib
, stdenv
, python
, toPythonModule
, fetchFromGitHub
, cmake
, swig
, cgal_5
}:

toPythonModule (stdenv.mkDerivation rec {
  pname = "cgal";
  version = "unstable-20220516";

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "cgal-swig-bindings";
    rev = version;
    sha256 = "sha256-OBPm/VCeqGskmpkgaYWHuGhaDycOOTyWDhPt1Bi8Zns=";
  };

  buildInputs = [ cgal_5 python ] ++ cgal_5.buildInputs;
  nativeBuildInputs = [ cmake swig ];

  cmakeFlags =  [
    "-DCGAL_DIR=${cgal_5}/lib/cmake/CGAL"
    "-DBUILD_JAVA=OFF"
    "-DPYTHON_OUTDIR_PREFIX=${placeholder "out"}/${python.sitePackages}/CGAL"
  ];

  meta = with lib; {
    description = "CGAL bindings using SWIG";
    homepage = "https://github.com/CGAL/cgal-swig-bindings";
    license = licenses.gpl3Plus;
  };
})

