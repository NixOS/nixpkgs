{ lib
, buildPythonPackage
, fetchFromGitHub
, defusedxml
, flaky
, keyring
, requests-mock
, requests_oauthlib
, requests-toolbelt
, setuptools-scm
, setuptools-scm-git-archive
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jira";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    rev = version;
    sha256 = "sha256-hAUAzkHPXFDlKEom+dkzr8GQ+sqK2Ci1/k+QuSNvifE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report=xml --cov jira" ""
  '';

  nativeBuildInputs = [ setuptools-scm setuptools-scm-git-archive ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    defusedxml
    keyring
    requests_oauthlib
    requests-toolbelt
  ];

  checkInputs = [
    flaky
    pytestCheckHook
    requests-mock
  ];

  # impure tests because of connectivity attempts to jira servers
  doCheck = false;

  meta = with lib; {
    description = "This library eases the use of the JIRA REST API from Python.";
    homepage = "https://github.com/pycontribs/jira";
    license = licenses.bsd2;
    maintainers = with maintainers; [ globin ];
  };
}
