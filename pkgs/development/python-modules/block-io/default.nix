{ stdenv, fetchPypi, buildPythonPackage, base58, ecdsa, pycryptodome, requests, six, setuptools }:

buildPythonPackage rec {
  pname = "block-io";
  version = "1.1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97ea037a67af72037cb08cec7e0a9f7866ecdfaa1a8c8ebcc0f4b9359a1516d7";
  };

  propagatedBuildInputs = [
    base58
    ecdsa
    pycryptodome
    requests
    six
    setuptools
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace "ecdsa==0.13" "ecdsa>=0.13"
  '';

  # Tests needs a BlockIO API key to run properly
  # https://github.com/BlockIo/block_io-python/blob/79006bc8974544b70a2d8e9f19c759941d32648e/test.py#L18
  doCheck = false;

  meta = with stdenv.lib; {
    broken = true;
    description = "Integrate Bitcoin, Dogecoin and Litecoin in your Python applications using block.io";
    homepage = "https://github.com/BlockIo/block_io-python";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
