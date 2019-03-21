{ stdenv, fetchPypi, fetchpatch, buildPythonPackage, base58, ecdsa, pycryptodome, requests, six }:

buildPythonPackage rec {
  pname = "block-io";
  version = "1.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4909d58b32ab7f93d3cd83fa4bbe4edef42ab7566f016bdb6a405a0d8b1907c9";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/BlockIo/block_io-python/commit/8ec0a0cd1afcfcb439d6dc306d8497dd9e4a0993.patch";
      sha256 = "1i6c153wvkr5ncm3cpn34faxvavz534x5kndwn4adlaxlzq30snn";
    })
  ];

  propagatedBuildInputs = [
    base58
    ecdsa
    pycryptodome
    requests
    six
  ];

  # Tests needs a BlockIO API key to run properly
  # https://github.com/BlockIo/block_io-python/blob/79006bc8974544b70a2d8e9f19c759941d32648e/test.py#L18
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Integrate Bitcoin, Dogecoin and Litecoin in your Python applications using block.io";
    homepage = https://github.com/BlockIo/block_io-python;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
