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
  version = "1.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Rtree";
    inherit version;
    hash = "sha256-b47lBN3l0AWyWwiq9b4LNASvOtX+zm4d3N41kIp5ipU=";
  };

  postPatch = ''
    substituteInPlace rtree/finder.py --replace \
      'find_library("spatialindex_c")' '"${libspatialindex}/lib/libspatialindex_c${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  buildInputs = [ libspatialindex ];

  nativeCheckInputs = [
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
