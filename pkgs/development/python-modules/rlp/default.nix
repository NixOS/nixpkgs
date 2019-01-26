{ lib, fetchPypi, buildPythonPackage, pytest, hypothesis, eth-utils }:

buildPythonPackage rec {
  pname = "rlp";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0ad3f3173dedf416565299f684717d4ae7620207d562d3ef94b818a40a48781";
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
