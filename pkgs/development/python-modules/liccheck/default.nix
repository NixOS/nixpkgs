{
  lib,
  buildPythonPackage,
  configparser,
  fetchFromGitHub,
  pip,
  pytest-mock,
  pytestCheckHook,
  python3-openid,
  pythonOlder,
  semantic-version,
  toml,
}:

buildPythonPackage rec {
  pname = "liccheck";
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dhatim";
    repo = "python-license-check";
    rev = "refs/tags/${version}";
    hash = "sha256-2WJw5TVMjOr+GX4YV0nssOtQeYvDHBLnlWquJQWPL9I=";
  };

  propagatedBuildInputs = [
    configparser
    semantic-version
    toml
  ];

  nativeCheckInputs = [
    pip
    pytest-mock
    pytestCheckHook
    python3-openid
  ];

  pythonImportsCheck = [ "liccheck" ];

  meta = with lib; {
    description = "Check python packages from requirement.txt and report issues";
    mainProgram = "liccheck";
    homepage = "https://github.com/dhatim/python-license-check";
    changelog = "https://github.com/dhatim/python-license-check/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
