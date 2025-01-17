{
  lib,
  apprise,
  babel,
  buildPythonPackage,
  click,
  cryptography,
  fetchPypi,
  gntp,
  installShellFiles,
  markdown,
  paho-mqtt,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  requests-oauthlib,
  setuptools,
  testers,
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "1.9.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KQ6xIXAo3VBAgCNxSU1wwbyrkH5mNKd8JjSJ2+T9c6g=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = [
    babel
    setuptools
  ];

  dependencies = [
    click
    cryptography
    markdown
    pyyaml
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    gntp
    paho-mqtt
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    installManPage packaging/man/apprise.1
  '';

  pythonImportsCheck = [ "apprise" ];

  passthru = {
    tests.version = testers.testVersion {
      package = apprise;
      version = "v${version}";
    };
  };

  meta = {
    description = "Push Notifications that work with just about every platform";
    homepage = "https://github.com/caronc/apprise";
    changelog = "https://github.com/caronc/apprise/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "apprise";
  };
}
