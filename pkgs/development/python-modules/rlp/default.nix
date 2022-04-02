{ lib, fetchPypi, buildPythonPackage, pytest, hypothesis, eth-utils }:

buildPythonPackage rec {
  pname = "rlp";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63b0465d2948cd9f01de449d7adfb92d207c1aef3982f20310f8009be4a507e8";
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
