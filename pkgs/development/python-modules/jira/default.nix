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
<<<<<<< HEAD
  version = "3.5.2";
=======
  version = "3.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-9hzKN57OHi2be9C2mtHZU1KcpbcKxiiYDj9Vw7MxTK4=";
=======
    hash = "sha256-6Nx12xEEPSWZE6XORU3I5HYM7vIjbAWPu7vNrzR4W24=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
