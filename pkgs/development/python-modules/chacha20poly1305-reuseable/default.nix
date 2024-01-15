{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, cython_3
, poetry-core
, setuptools

# propagates
, cryptography

# tests
, pytestCheckHook
}:

let
  pname = "chacha20poly1305-reuseable";
  version = "0.12.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g1sLmYy5SClkdBSjFFYtikh2nuxfTIoaCyktqoFl+Ho=";
  };

  nativeBuildInputs = [
    cython_3
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  pythonImportsCheck = [
    "chacha20poly1305_reuseable"
  ];

  preCheck = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=chacha20poly1305_reuseable --cov-report=term-missing:skip-covered" ""
  '';

  nativeCheckInputs = [
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
