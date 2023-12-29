{ lib
, buildPythonPackage
, fetchPypi
, toml
}:

buildPythonPackage rec {
  pname = "confight";
  version = "2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iodoexnh9tG4dgkjDXCUzWRFDhRlJ3HRgaNhxG2lwPY=";
  };

  propagatedBuildInputs = [
    toml
  ];

  pythonImportsCheck = [ "confight" ];

  doCheck = false;

  meta = with lib; {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/avature/confight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mkg20001 ];
  };
}
