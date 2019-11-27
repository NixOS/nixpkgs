{ lib, fetchFromGitHub, buildPythonPackage, pytest, eth-hash, eth-typing,
  cytoolz, hypothesis }:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "1.8.1";

  # Tests are missing from the PyPI source tarball so let's use GitHub
  # https://github.com/ethereum/eth-utils/issues/130
  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kr4hw2l1ck22sk187wvg2pxh3mknjp2xjxjizgwvdsxqqqsxpg4";
  };

  checkInputs = [ pytest hypothesis ];
  propagatedBuildInputs = [ eth-hash eth-typing cytoolz ];

  # setuptools-markdown uses pypandoc which is broken at the moment
  preConfigure = ''
    substituteInPlace setup.py --replace \'setuptools-markdown\' ""
  '';

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = https://github.com/ethereum/eth-utils;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
