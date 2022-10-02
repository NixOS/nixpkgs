{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-context";
  version = "4.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gfrDZW4d3X/QjUBN8DFSvKRLZge3pnZ6KkI7S7Nz3W0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonNamespaces = [
    "jaraco"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "jaraco.context" ];

  meta = with lib; {
    description = "Python module for context management";
    homepage = "https://github.com/jaraco/jaraco.context";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
