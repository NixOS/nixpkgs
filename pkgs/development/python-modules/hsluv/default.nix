{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hsluv";
  version = "5.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hsluv";
    repo = "hsluv-python";
    rev = "v${version}";
    hash = "sha256-bjivmPTU3Gp3pcC0ru4GSZANdhPqS1QSTMeiPGN8GCI=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hsluv" ];

  meta = {
    description = "Python implementation of HSLuv";
    homepage = "https://github.com/hsluv/hsluv-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
