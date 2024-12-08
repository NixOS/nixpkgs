{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  eth-hash,
  eth-typing,
  cytoolz,
  hypothesis,
  isPyPy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  toolz,
  mypy,
}:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "5.1.0";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-utils";
    rev = "v${version}";
    hash = "sha256-uPzg1gUEsulQL2u22R/REHWx1ZtbMxvcXf6UgWqkDF4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    eth-hash
    eth-typing
  ] ++ lib.optional (!isPyPy) cytoolz ++ lib.optional isPyPy toolz;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    mypy
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_utils" ];

  disabledTests = [ "test_install_local_wheel" ];

  meta = with lib; {
    changelog = "https://github.com/ethereum/eth-utils/blob/${src.rev}/docs/release_notes.rst";
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
