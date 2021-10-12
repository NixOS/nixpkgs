{ lib, fetchPypi, buildPythonPackage, base58, ecdsa, pycryptodome, requests, six, setuptools }:

buildPythonPackage rec {
  pname = "block-io";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "817c9cd2ff76659caca4bb3d6758d5782a85f8c0ea13b08c4e14f0c2a8b7586d";
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
