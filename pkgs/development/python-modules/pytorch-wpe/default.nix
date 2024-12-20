{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  numpy,
  torch,
  torch-complex,
}:
buildPythonPackage rec {
  pname = "pytorch-wpe";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "nttcslab-sp";
    repo = "dnn_wpe";
    tag = "v${version}";
    hash = "sha256-DcT0NnnbcSYYyVpH7JqAnpjOANS2INBYQLV9Qx3BwZw=";
  };

  propagatedBuildInputs = [
    numpy
    torch
    torch-complex
  ];

  pythonImportsCheck = [ "pytorch_wpe" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "WPE implementation using PyTorch";
    homepage = "https://github.com/nttcslab-sp/dnn_wpe";
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
