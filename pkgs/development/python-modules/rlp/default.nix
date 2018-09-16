{ lib, fetchPypi, buildPythonPackage, pytest, hypothesis, eth-utils }:

buildPythonPackage rec {
  pname = "rlp";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "040fb5172fa23d27953a886c40cac989fc031d0629db934b5a9edcd2fb28df1e";
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
