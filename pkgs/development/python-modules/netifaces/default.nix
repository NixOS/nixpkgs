{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "netifaces";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BDp5FG6ykH7fQ5iZ8mKz3+QXF9NBJCmO0oETmouTyjI=";
  };

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "netifaces" ];

  meta = {
    description = "Portable access to network interfaces from Python";
    homepage = "https://github.com/al45tair/netifaces";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
