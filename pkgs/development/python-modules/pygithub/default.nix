{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, pynacl
, typing-extensions
, pyjwt
, python-dateutil
, pythonOlder
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pygithub";
  version = "1.59.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "refs/tags/v${version}";
    hash = "sha256-tzM2+nLBHTbKlQ7HLmNRq4Kn62vmz1MaGyZsnaJSrgQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    deprecated
    pyjwt
    pynacl
    python-dateutil
    requests
    typing-extensions
  ] ++ pyjwt.optional-dependencies.crypto;

  # Test suite makes REST calls against github.com
  doCheck = false;

  pythonImportsCheck = [
    "github"
  ];

  meta = with lib; {
    description = "Python library to access the GitHub API v3";
    homepage = "https://github.com/PyGithub/PyGithub";
    changelog = "https://github.com/PyGithub/PyGithub/raw/v${version}/doc/changes.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jhhuh ];
  };
}
