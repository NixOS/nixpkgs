{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hpack";
  version = "4.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "hpack";
    rev = "v${version}";
    hash = "sha256-2CehGy3K5fKbkB1J8+8x1D4XvnBn1Mbapx+p8rdXDYc=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hpack" ];

  meta = with lib; {
    description = "Pure-Python HPACK header compression";
    homepage = "https://github.com/python-hyper/hpack";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
