{ lib
, buildPythonPackage
, fetchPypi
, toml
}:

buildPythonPackage rec {
  pname = "confight";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fJr7f9Y/zEpCedWYd04AMuhkOFqZLJOw4sDiz8SDQ/Y=";
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
