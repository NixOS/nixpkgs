{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvesync";
  version = "1.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8bc6ebbe2c2bf37009b50b16e34747b0cfe35dd249aed4525b68c3af061941f";
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
