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
  version = "2.3.0";  # Komikku not launching w/ 3.0.0, #280551

  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eigenein";
    repo = "protobuf";
    rev = "refs/tags/${version}";
    hash = "sha256-nJ3F8dUrqMeWqTV9ErGqrMvofJwBKwNUDfxWIqFh4nY=";
  };

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
    changelog = "https://github.com/eigenein/protobuf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
