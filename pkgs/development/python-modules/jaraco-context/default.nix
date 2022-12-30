{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-context";
  version = "4.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-J7vL+pvwXcKEkqZn44/U01HmP1CI5kIGsJ1aJevp0I4=";
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
