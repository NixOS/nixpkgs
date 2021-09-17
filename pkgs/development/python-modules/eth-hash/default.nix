{ lib, fetchPypi, buildPythonPackage, pythonOlder, pytest, pysha3, pycrypto
, pycryptodome
, eth-utils
}:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f40cecd5ead88184aa9550afc19d057f103728108c5102f592f8415949b5a76";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    pysha3
    pycrypto
    pycryptodome
  ];

  pipInstallFlags = [
    # Circular dependency on eth-utils
    "--no-dependencies"
  ];

  # setuptools-markdown uses pypandoc which is broken at the moment
  preConfigure = ''
    substituteInPlace setup.py --replace \'setuptools-markdown\' ""
  '';

  # Run tests separately because we don't want to run tests on tests/backends/
  # but only on its selected subdirectories. Also, the directories under
  # tests/backends/ must be run separately because they have identically named
  # test files so pytest would raise errors because of that.
  #
  # Also, tests in tests/core/test_import.py are broken so just ignore them:
  # https://github.com/ethereum/eth-hash/issues/25
  # There is a pull request to fix the tests:
  # https://github.com/ethereum/eth-hash/pull/26
  checkPhase = ''
    pytest tests/backends/pycryptodome/
    pytest tests/backends/pysha3/
    # pytest tests/core/
  '';

  disabled = pythonOlder "3.5";

  meta = {
    description = "The Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
