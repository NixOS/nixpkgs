{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools-scm,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaraco-classes";
  version = "3.3.1";
  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.classes";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ds84jNEx/2/BnMTbLMvXf/nxKSqyCBM7B7S0NNYagVE=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ more-itertools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Utility functions for Python class constructs";
    homepage = "https://github.com/jaraco/jaraco.classes";
    license = licenses.mit;
  };
}
