{ stdenv, fetchPypi, fetchpatch, buildPythonPackage, base58, ecdsa, pycryptodome, requests, six }:

buildPythonPackage rec {
  pname = "block-io";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15468pvpcp41ly7kjpmikpyi4av57d9zhf5j1v01j78r1xqqk56g";
  };

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
