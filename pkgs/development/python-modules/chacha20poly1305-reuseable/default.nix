{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cython,
  poetry-core,
  setuptools,

  # propagates
  cryptography,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

let
  pname = "chacha20poly1305-reuseable";
  version = "0.13.2";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "chacha20poly1305-reuseable";
    tag = "v${version}";
    hash = "sha256-i6bhqfYo+gFTf3dqOBSQqGN4WPqbUR05StdwZvrVckI=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  pythonRelaxDeps = [ "cryptography" ];

  propagatedBuildInputs = [ cryptography ];

  pythonImportsCheck = [ "chacha20poly1305_reuseable" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ChaCha20Poly1305 that is reuseable for asyncio";
    homepage = "https://github.com/bdraco/chacha20poly1305-reuseable";
    changelog = "https://github.com/bdraco/chacha20poly1305-reuseable/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
