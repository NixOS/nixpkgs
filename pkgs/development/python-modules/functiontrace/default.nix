{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "functiontrace";
  version = "0.3.10";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E2MNp3wKb9FEjEQK/vL/XBfScPuAwbWV5JeA9+ujckY=";
  };

  nativeBuildInputs = [
    setuptools
    toml
  ];

  pythonImportsCheck = [ "functiontrace" ];

  meta = with lib; {
    homepage = "https://functiontrace.com";
    description = "Python module for Functiontrace";
    license = licenses.prosperity30;
    maintainers = with maintainers; [ mathiassven ];
  };
}
