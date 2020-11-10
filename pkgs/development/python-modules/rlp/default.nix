{ lib, fetchPypi, buildPythonPackage, pytest, hypothesis, eth-utils }:

buildPythonPackage rec {
  pname = "rlp";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27273fc2dbc3513c1e05ea6b8af28aac8745fb09c164e39e2ed2807bf7e1b342";
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
