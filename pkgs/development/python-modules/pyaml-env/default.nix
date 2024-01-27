{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyaml-env";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkaranasou";
    repo = "pyaml_env";
    rev = "v${version}";
    hash = "sha256-xSu+dksSVugShJwOqedXBrXIKaH0G5JAsynauOuP3OA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyaml_env" ];

  meta = with lib; {
    description = "Parse YAML configuration with environment variables in Python";
    homepage = "https://github.com/mkaranasou/pyaml_env";
    license = licenses.mit;
    maintainers = with maintainers; [ edmundmiller ];
  };
}
