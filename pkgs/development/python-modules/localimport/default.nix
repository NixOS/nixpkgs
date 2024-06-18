{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "localimport";
  version = "1.7.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8UhaZyGdN/N6UwR7pPYQR2hZCz3TrBxr1KOBJRx28ok=";
  };

  pythonImportsCheck = [ "localimport" ];

  meta = with lib; {
    homepage = "https://github.com/NiklasRosenstein/py-localimport";
    description = "Isolated import of Python modules";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
