{ lib
, buildPythonPackage
, fetchFromGitHub
, defusedxml
, flaky
, keyring
, requests-mock
, requests-oauthlib
, requests-toolbelt
, setuptools-scm
, setuptools-scm-git-archive
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jira";
  version = "3.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-n0V9FZ1agzvzqCriqls8C2IKhHKOmOAWqa8iCnXHKY4=";
  };

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    defusedxml
    keyring
    requests-oauthlib
    requests-toolbelt
  ];

  nativeCheckInputs = [
    flaky
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report=xml --cov jira" ""
  '';

  pythonImportsCheck = [
    "jira"
  ];

  # impure tests because of connectivity attempts to jira servers
  doCheck = false;

  meta = with lib; {
    description = "Library to interact with the JIRA REST API";
    homepage = "https://github.com/pycontribs/jira";
    changelog = "https://github.com/pycontribs/jira/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ globin ];
  };
}
