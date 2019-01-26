{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, pytest }:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "1.3.0";

  # Tests are missing from the PyPI source tarball so let's use GitHub
  # https://github.com/ethereum/eth-typing/issues/8
  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0703z7vlsfa3dvgcq22f9rzmj0svyp2a8wc7h73d0aac28ydhpv9";
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
