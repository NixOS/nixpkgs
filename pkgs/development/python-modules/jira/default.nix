{ lib
, buildPythonPackage
, fetchFromGitHub
, defusedxml
, flaky
, ipython
, keyring
, packaging
, pillow
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, requests-futures
, requests-mock
, requests-oauthlib
, requests-toolbelt
, setuptools
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jira";
  version = "3.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zE0fceCnyv0qKak8sRCXPCauC0KeOmczY/ZkVoHNcS8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    defusedxml
    packaging
    requests
    requests-oauthlib
    requests-toolbelt
    pillow
    typing-extensions
  ];

  passthru.optional-dependencies = {
    cli = [
      ipython
      keyring
    ];
    opt = [
      # filemagic
      pyjwt
      # requests-jwt
      # requests-keyberos
    ];
    async = [
      requests-futures
    ];
  };

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
    maintainers = with maintainers; [ ];
    mainProgram = "jirashell";
  };
}
