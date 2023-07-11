{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools-scm
, lsprotocol
, toml
, typeguard
, mock
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = "pygls";
    rev = "refs/tags/v${version}";
    hash = "sha256-ovm897Vu6HRziGee3NioM1BA65mLe3F5Z2k0E+A35Gs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [
    lsprotocol
    typeguard
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString stdenv.isDarwin ''
    # Darwin issue: OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    changelog = "https://github.com/openlawlibrary/pygls/blob/${src.rev}/CHANGELOG.md";
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
