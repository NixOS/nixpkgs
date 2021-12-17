{ lib, fetchPypi, buildPythonPackage, base58, ecdsa, pycryptodome, requests, six, setuptools }:

buildPythonPackage rec {
  pname = "block-io";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af70c3be444f2f2d07c0603cef547b51bbd9f4fbd4aadebd8f1e8ee73ccbc5e5";
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
      --replace "ecdsa==0.15" "ecdsa>=0.15" \
      --replace "base58==1.0.3" "base58>=1.0.3"
  '';

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
