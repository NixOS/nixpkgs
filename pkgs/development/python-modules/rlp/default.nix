{ lib
, fetchFromGitHub
, buildPythonPackage
, eth-utils
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rlp";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "pyrlp";
    rev = "v${version}";
    hash = "sha256-GRCq4FU38e08fREg5fweig5Y60jLT2k3Yj1Jk8OA6XY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'setuptools-markdown'" ""
  '';

  propagatedBuildInputs = [
    eth-utils
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rlp" ];

  meta = with lib; {
    description = "RLP serialization library";
    homepage = "https://github.com/ethereum/pyrlp";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
