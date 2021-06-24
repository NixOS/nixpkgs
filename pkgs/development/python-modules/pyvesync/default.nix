{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvesync";
  version = "1.3.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02fpbyg46mlpc2c1j4zylw9a1h6bacxvigrl3cndsf6fxlhfx15z";
  };

  propagatedBuildInputs = [ requests ];

  # Test are not available (not in PyPI tarball and there are no GitHub releases)
  doCheck = false;
  pythonImportsCheck = [ "pyvesync" ];

  meta = with lib; {
    description = "Python library to manage Etekcity Devices and Levoit Air Purifier";
    homepage = "https://github.com/webdjoe/pyvesync";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
