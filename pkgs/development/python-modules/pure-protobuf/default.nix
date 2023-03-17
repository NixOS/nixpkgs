{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools-scm
, toml
, pytestCheckHook
, pytest-benchmark
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "pure-protobuf";
  version = "2.2.3";

  format = "pyproject";
  disabled = pythonOlder "3.7";

  # PyPi lacks tests.
  src = fetchFromGitHub {
    owner = "eigenein";
    repo = "protobuf";
    rev = version;
    hash = "sha256-FsVWlYPav4uusdEPXc5hScLeNJWfbSjGOLuZ7yZXyCw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  checkInputs = [
    pytestCheckHook
    pytest-benchmark
  ];

  pythonImportsCheck = [
    "pure_protobuf"
  ];

  meta = with lib; {
    description = "Python implementation of Protocol Buffers with dataclass-based schemas";
    homepage = "https://github.com/eigenein/protobuf";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
