{ lib
, buildPythonPackage
, fetchPypi
, numpy
, laszip
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "laspy";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wdbp6kjuZkJh+pp9OVczdsRNgn41/Tdt7nGFvewcQ1w=";
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
