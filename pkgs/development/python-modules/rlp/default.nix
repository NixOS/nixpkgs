{ lib, fetchPypi, buildPythonPackage, pytest, hypothesis, eth-utils }:

buildPythonPackage rec {
  pname = "rlp";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "665e8312750b3fc5f7002e656d05b9dcb6e93b6063df40d95c49ad90c19d1f0e";
  };

  checkInputs = [ pytest hypothesis ];
  propagatedBuildInputs = [ eth-utils ];

  # setuptools-markdown uses pypandoc which is broken at the moment
  preConfigure = ''
    substituteInPlace setup.py --replace \'setuptools-markdown\' ""
    substituteInPlace setup.py --replace "long_description_markdown_filename='README.md'," ""
  '';

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "A package for encoding and decoding data in and from Recursive Length Prefix notation";
    homepage = "https://github.com/ethereum/pyrlp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
