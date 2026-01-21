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
  pyyaml,
  requests,
  requests-oauthlib,
  setuptools,
  stdenv,
  terminal-notifier,
  testers,
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "1.9.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qga+nLVpSj0I3Y4Dk7u5s2ISrDp3acJjNiAFXnXGyu8=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace apprise/plugins/macosx.py \
    --replace-fail "/opt/homebrew/bin/terminal-notifier" "${lib.getExe' terminal-notifier "terminal-notifier"}"
  '';

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
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "apprise";
  };
}
