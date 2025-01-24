{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  mock,
  setuptools,
  tox,
}:

buildPythonPackage rec {
  pname = "routeros-api";
  version = "0.18.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "socialwifi";
    repo = "routeros-api";
    rev = "refs/tags/${version}";
    hash = "sha256-6IpoByG3YhHh2dPS18ufaoI1vzTZBsZa9WNHS/fImrg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    tox
  ];

  pythonImportsCheck = [ "routeros_api" ];

  meta = with lib; {
    description = "Python API to RouterBoard devices produced by MikroTik";
    homepage = "https://github.com/socialwifi/RouterOS-api";
    changelog = "https://github.com/socialwifi/RouterOS-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ quentin ];
  };
}
