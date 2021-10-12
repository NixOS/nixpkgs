{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mvkhkrhzzzng17j2yvwp4x1hj8wls3qw5lngqs777a2qc1mhg0r";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "dotmap/test.py" ];

  pythonImportsCheck = [ "dotmap" ];

  meta = with lib; {
    description = "Python for dot-access dictionaries";
    homepage = "https://github.com/drgrib/dotmap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
