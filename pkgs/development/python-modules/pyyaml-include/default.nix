{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pyyaml
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "pyyaml-include";
  version = "1.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tanbro";
    repo = "pyyaml-include";
    rev = "refs/tags/v${version}";
    hash = "sha256-xsNMIEBYqMVQp+H8R7XpFCwROXA8I6bFvAuHrRvC+DI=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yamlinclude" ];

  meta = with lib; {
    description = "Extending PyYAML with a custom constructor for including YAML files within YAML files";
    homepage = "https://github.com/tanbro/pyyaml-include";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
