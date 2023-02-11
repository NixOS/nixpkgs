{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PV3ybMfsmuu/hCoJEVovqF3FnqZBT6VoVyxEd115bLw=";
  };

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [
    "puremagic"
  ];

  meta = with lib; {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
