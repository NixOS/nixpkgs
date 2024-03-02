{ lib
, buildPythonPackage
, fetchFromGitHub
, grpcio
, protobuf
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "aetcd";
  version = "1.0.0a4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "martyanov";
    repo = "aetcd";
    rev = "refs/tags/v${version}";
    hash = "sha256-g49ppfh8dyGpZeu/HdTDX8RAk5VTcZmqENRpNY12qkg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm==6.3.2" "setuptools_scm"
    substituteInPlace setup.cfg \
      --replace-fail "--cov=aetcd" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aetcd"
  ];

  disabledTestPaths = [
    # Tests require a running ectd instance
    "tests/integration/"
  ];

  meta = with lib; {
    description = "Python asyncio-based client for etcd";
    homepage = "https://github.com/martyanov/aetcd";
    changelog = "https://github.com/martyanov/aetcd/blob/v${version}/docs/changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
