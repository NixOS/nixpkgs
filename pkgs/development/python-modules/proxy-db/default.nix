{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  six,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "proxy-db";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Nekmo";
    repo = "proxy-db";
    tag = "v${version}";
    hash = "sha256-NdbvK2sJKKoWNYsuBaCMWtKEvuMhgyKXcKZXQgTC4bY=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    click
    requests
    six
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "proxy_db" ];

  meta = with lib; {
    description = "Module to manage proxies in a local database";
    mainProgram = "proxy-db";
    homepage = "https://github.com/Nekmo/proxy-db/";
    changelog = "https://github.com/Nekmo/proxy-db/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
