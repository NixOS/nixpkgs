{
  lib,
  fetchPypi,
  bitcoin-utils-fork-minimal,
  buildPythonPackage,
  base58,
  pycryptodome,
  requests,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "block-io";
  version = "2.0.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M7czfpagXqoWWSu4enB3Z2hc2GtAaskI6cnJzJdpC8I=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "base58" ];

  dependencies = [
    base58
    bitcoin-utils-fork-minimal
    pycryptodome
    requests
    setuptools
  ];

  # Tests needs a BlockIO API key to run properly
  # https://github.com/BlockIo/block_io-python/blob/79006bc8974544b70a2d8e9f19c759941d32648e/test.py#L18
  doCheck = false;

  pythonImportsCheck = [ "block_io" ];

  meta = with lib; {
    description = "Integrate Bitcoin, Dogecoin and Litecoin in your Python applications using block.io";
    homepage = "https://github.com/BlockIo/block_io-python";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
