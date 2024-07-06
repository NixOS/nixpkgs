{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pyaml
}:

buildPythonPackage rec {
  pname = "pyaml_env";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash =  "sha256-bV3JjIyC33Q6EywZbnmWMFDJ/rBbCm8l8613dx09lbA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyaml
  ];

  pythonImportsCheck = [ "pyaml" ];

  meta = with lib; {
    description = "Python YAML configuration with environment variables parsing";
    mainProgram = "pyaml_env";
    homepage = "https://github.com/mkaranasou/pyaml_env";
    license = licenses.mit;
    maintainers = with maintainers; [ apraga ];
  };
}
