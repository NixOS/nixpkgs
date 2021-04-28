{ lib, buildPythonPackage, fetchPypi, installShellFiles
, Babel, requests, requests_oauthlib, six, click, markdown, pyyaml, cryptography
, pytestrunner, coverage, flake8, mock, pytestCheckHook, pytestcov, tox, gntp, sleekxmpp
}:

buildPythonPackage rec {
  pname = "apprise";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FW5gt35yoXVr2+hiGBDJ/5jFFfIpn2Z9sDN8acoO4FI=";
  };

  nativeBuildInputs = [ Babel installShellFiles ];

  propagatedBuildInputs = [
    cryptography requests requests_oauthlib six click markdown pyyaml
  ];

  checkInputs = [
    pytestrunner coverage flake8 mock pytestCheckHook pytestcov tox gntp sleekxmpp
  ];

  disabledTests = [ "test_apprise_cli_nux_env"  ];

  postInstall = ''
    installManPage packaging/man/apprise.1
  '';

  pythonImportsCheck = [ "apprise" ];

  meta = with lib; {
    homepage = "https://github.com/caronc/apprise";
    description = "Push Notifications that work with just about every platform!";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
