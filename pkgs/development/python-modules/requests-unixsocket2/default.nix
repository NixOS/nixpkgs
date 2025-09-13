{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  requests,
  poetry-core,
  pytestCheckHook,
  urllib3,
  waitress,
}:

buildPythonPackage rec {
  pname = "requests-unixsocket2";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "thelabnyc";
    repo = "requests-unixsocket2";
    tag = "v${version}";
    hash = "sha256-HD68YczUy7bexm3Rrh0OfgOux3ItSYQB9lj68p7WtnU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    waitress
  ];

  pythonImportsCheck = [ "requests_unixsocket" ];

  meta = {
    changelog = "https://gitlab.com/thelabnyc/requests-unixsocket2/-/blob/${src.tag}/CHANGELOG.md";
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage = "https://gitlab.com/thelabnyc/requests-unixsocket2";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ mikut ];
  };
}
