{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, setuptools-scm
, more-itertools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaraco-classes";
  version = "3.3.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.classes";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DW8qf6G6997vBOaO1+Bdx4LBvKfpl/MiiFqWJYKE/pg=";
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
