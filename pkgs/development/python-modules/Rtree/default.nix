{ lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libspatialindex,
  numpy,
  pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Rtree";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be8772ca34699a9ad3fb4cfe2cfb6629854e453c10b3328039301bbfc128ca3e";
  };

  buildInputs = [ libspatialindex ];

  patchPhase = ''
    substituteInPlace rtree/finder.py --replace \
      "find_library('spatialindex_c')" "'${libspatialindex}/lib/libspatialindex_c${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  checkInputs = [
    numpy
    pytestCheckHook
  ];
  pythonImportsCheck = [ "rtree" ];

  meta = with lib; {
    description = "R-Tree spatial index for Python GIS";
    homepage = "https://toblerity.org/rtree/";
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
