{ lib, fetchFromGitHub, buildPythonPackage, pytestCheckHook, eth-hash, eth-typing,
  cytoolz, hypothesis }:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "1.9.5";

  # Tests are missing from the PyPI source tarball so let's use GitHub
  # https://github.com/ethereum/eth-utils/issues/130
  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h3xlw74zdf6cfvqf9193lx05bpdm05pmy9ap1g7q2kx0j2b6352";
  };

  checkInputs = [ pytestCheckHook hypothesis ];
  propagatedBuildInputs = [ eth-hash eth-typing cytoolz ];

  pythonImportsCheck = [ "eth_utils" ];

  meta = {
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
