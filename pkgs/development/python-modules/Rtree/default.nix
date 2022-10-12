{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, libspatialindex
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rtree";
  version = "1.0.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Rtree";
    inherit version;
    sha256 = "sha256-IiEhaZwwOmQGXYSb9wOLHsq8N7Zcf6NAvts47w6AVCk=";
  };

  postPatch = ''
    substituteInPlace rtree/finder.py --replace \
      'find_library("spatialindex_c")' '"${libspatialindex}/lib/libspatialindex_c${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  buildInputs = [ libspatialindex ];

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
