{ lib
, fetchPypi
, bitcoin-utils-fork-minimal
, buildPythonPackage
, base58
, pycryptodome
, requests
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "block-io";
  version = "2.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af70c3be444f2f2d07c0603cef547b51bbd9f4fbd4aadebd8f1e8ee73ccbc5e5";
  };

  propagatedBuildInputs = [
    base58
    bitcoin-utils-fork-minimal
    pycryptodome
    requests
    setuptools
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace "base58==2.1.0" "base58>=2.1.0"
  '';

  # Tests needs a BlockIO API key to run properly
  # https://github.com/BlockIo/block_io-python/blob/79006bc8974544b70a2d8e9f19c759941d32648e/test.py#L18
  doCheck = false;

  pythonImportsCheck = [
    "block_io"
  ];

  meta = with lib; {
    description = "Integrate Bitcoin, Dogecoin and Litecoin in your Python applications using block.io";
    homepage = "https://github.com/BlockIo/block_io-python";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
