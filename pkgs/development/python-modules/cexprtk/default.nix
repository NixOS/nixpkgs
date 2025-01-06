{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cexprtk";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QhftIybufVPO/YbLFycR4qYEAtQMcRPP5jKS6o6dFZg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cexprtk" ];

  meta = {
    description = "Mathematical expression parser, cython wrapper";
    homepage = "https://github.com/mjdrushton/cexprtk";
    license = lib.licenses.cpl10;
    maintainers = with lib.maintainers; [ onny ];
  };
}
