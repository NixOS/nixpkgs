{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "netifaces";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BDp5FG6ykH7fQ5iZ8mKz3+QXF9NBJCmO0oETmouTyjI=";
  };

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "netifaces" ];

  meta = with lib; {
    description = "Portable access to network interfaces from Python";
    homepage = "https://github.com/al45tair/netifaces";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
