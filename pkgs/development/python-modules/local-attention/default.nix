{
  lib,
  buildPythonPackage,
  torch,
  einops,
  fetchurl,
  setuptools,
}:
buildPythonPackage {
  pname = "local-attention";
  version = "1.9.15";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/86/88/1a952205a1f40c38ff3c956d245ff4f0579208ba5859c05124b2d937dcc5/local_attention-1.9.15-py3-none-any.whl";
    sha256 = "sha256-0wVb24fBqKaMZ5W4SbRT6pwq2w3EJtcvcb1T+Evm4Ns=";
  };

  build-system = [ setuptools ];

  dependencies = [
    torch
    einops
  ];

  pythonImportsCheck = [
    "local_attention"
  ];

  meta = {
    description = "Local attention, window with lookback, for language modeling";
    homepage = "https://github.com/lucidrains/local-attention";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hakan-demirli ];
  };
}
