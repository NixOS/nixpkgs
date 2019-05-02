{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, pytest }:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "2.0.0";

  # Tests are missing from the PyPI source tarball so let's use GitHub
  # https://github.com/ethereum/eth-typing/issues/8
  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "017rshrz9kzax851hdbd3924jmr06h2sx3xdq7m4dwhgz3pgqfcy";
  };

  # setuptools-markdown uses pypandoc which is broken at the moment
  preConfigure = ''
    substituteInPlace setup.py --replace \'setuptools-markdown\' ""
  '';

  disabled = pythonOlder "3.5";

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "Common type annotations for Ethereum Python packages";
    homepage = https://github.com/ethereum/eth-typing;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
