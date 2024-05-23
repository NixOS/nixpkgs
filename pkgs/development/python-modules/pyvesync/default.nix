{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyvesync";
  version = "2.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ddtTtTAUpvS8DN1vKVN+CjnmYp20xyxHydwOaDRjWzo=";
  };

  propagatedBuildInputs = [ requests ];

  # Test are not available (not in PyPI tarball and there are no GitHub releases)
  doCheck = false;

  pythonImportsCheck = [ "pyvesync" ];

  meta = with lib; {
    description = "Python library to manage Etekcity Devices and Levoit Air Purifier";
    homepage = "https://github.com/webdjoe/pyvesync";
    changelog = "https://github.com/webdjoe/pyvesync/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
