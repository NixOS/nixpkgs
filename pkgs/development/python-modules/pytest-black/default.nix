{
  lib,
  buildPythonPackage,
  fetchPypi,
  black,
  pytest,
  setuptools-scm,
  toml,
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HTObAE92TWzQ8G5pD23XSN89Yub+GmktalUArCxbdaU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    black
    toml
  ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_black" ];

  meta = with lib; {
    description = "Pytest plugin to enable format checking with black";
    homepage = "https://github.com/shopkeep/pytest-black";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
