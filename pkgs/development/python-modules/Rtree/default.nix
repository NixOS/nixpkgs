{ lib, stdenv, buildPythonPackage, fetchPypi, libspatialindex, numpy }:

buildPythonPackage rec {
  pname = "Rtree";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be8772ca34699a9ad3fb4cfe2cfb6629854e453c10b3328039301bbfc128ca3e";
  };

  propagatedBuildInputs = [ libspatialindex ];

  patchPhase = ''
    substituteInPlace rtree/core.py --replace \
      "find_library('spatialindex_c')" "'${libspatialindex}/lib/libspatialindex_c${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  # Tests appear to be broken due to mysterious memory unsafe issues. See #36760
  doCheck = false;
  checkInputs = [ numpy ];

  meta = with lib; {
    description = "R-Tree spatial index for Python GIS";
    homepage = "https://toblerity.org/rtree/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ bgamari ];
  };
}
