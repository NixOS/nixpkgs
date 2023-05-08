{ lib
, buildPythonPackage
, fetchPypi
, numpy
, laszip
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "laspy";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E8rsxzJcsiQsslOUmE0hs7X3lsiLy0S8LtLTzxuXKsQ=";
  };

  propagatedBuildInputs = [
    numpy
    laszip
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "laspy" "laszip" ];

  meta = with lib; {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    homepage = "https://github.com/laspy/laspy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
