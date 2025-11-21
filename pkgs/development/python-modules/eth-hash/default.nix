{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  isPyPy,
  # nativeCheckInputs
  pytest,
  pytest-xdist,
  # optional dependencies
  pycryptodome,
  safe-pysha3,
}:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-hash";
    tag = "v${version}";
    hash = "sha256-91jWZDqrd7ZZlM0D/3sDokJ26NiAQ3gdeBebTV1Lq8s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest
    pytest-xdist
  ]
  ++ optional-dependencies.pycryptodome
  # safe-pysha3 is not available on pypy
  ++ lib.optional (!isPyPy) optional-dependencies.pysha3;

  # Backends need to be tested separately and can not use hook
  checkPhase = ''
    runHook preCheck
    pytest tests/core tests/backends/pycryptodome
  ''
  + lib.optionalString (!isPyPy) ''
    pytest tests/backends/pysha3
  ''
  + ''
    runHook postCheck
  '';

  optional-dependencies = {
    pycryptodome = [ pycryptodome ];
    pysha3 = [ safe-pysha3 ];
  };

  meta = {
    description = "Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    changelog = "https://github.com/ethereum/eth-hash/blob/v${version}/docs/release_notes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
