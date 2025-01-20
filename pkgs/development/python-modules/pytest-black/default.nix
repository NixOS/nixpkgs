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
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7Ld0VfN5gFy0vY9FqBOjdUw7vuMZmt8bNmXA39CGtRE=";
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
    maintainers = [ ];
  };
}
