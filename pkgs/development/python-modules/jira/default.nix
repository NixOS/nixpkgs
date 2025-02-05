{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  defusedxml,
  flaky,
  ipython,
  keyring,
  packaging,
  pillow,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-futures,
  requests-mock,
  requests-oauthlib,
  requests-toolbelt,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "jira";
  version = "3.9.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    tag = version;
    hash = "sha256-P3dbrBKpHvLNIA+JBeSXEQl4QVZ0FdKkNIU8oPHWw6k=";
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

  optional-dependencies = {
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
    async = [ requests-futures ];
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

  pythonImportsCheck = [ "jira" ];

  # impure tests because of connectivity attempts to jira servers
  doCheck = false;

  meta = with lib; {
    description = "Library to interact with the JIRA REST API";
    homepage = "https://github.com/pycontribs/jira";
    changelog = "https://github.com/pycontribs/jira/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "jirashell";
  };
}
