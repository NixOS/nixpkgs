{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pythonAtLeast,
  pythonOlder,
  pycryptodome,
  pytest,
  pytest-xdist,
  safe-pysha3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.7.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-hash";
    rev = "refs/tags/v${version}";
    hash = "sha256-tFKq+WN8Z1BIAOIfaRtVt4+pnZ99FwHO8/pycmQx5Gg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs =
    [
      pytest
      pytest-xdist
    ]
    ++ passthru.optional-dependencies.pycryptodome
    # safe-pysha3 is not available on pypy
    ++ lib.optional (!isPyPy) passthru.optional-dependencies.pysha3;

  # Backends need to be tested separatly and can not use hook
  checkPhase =
    ''
      runHook preCheck
      pytest tests/core tests/backends/pycryptodome
    ''
    + lib.optionalString (!isPyPy) ''
      pytest tests/backends/pysha3
    '';

  passthru.optional-dependencies = {
    pycryptodome = [ pycryptodome ];
    pysha3 = [ safe-pysha3 ];
  };

  meta = {
    changelog = "https://github.com/ethereum/eth-hash/blob/v${version}/docs/release_notes.rst";
    description = "Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
}
