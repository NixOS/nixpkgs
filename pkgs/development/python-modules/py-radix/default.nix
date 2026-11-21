{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-radix";
  version = "ersion/1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjschultz";
    repo = "py-radix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+ub8wPjQVMc1fw57dF0ACVU0PPyMKtypbALydcXtEmc=";
  };

  pythonImportsCheck = [ "radix" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python radix tree implementation for IPv4 and IPv6 prefix matching";
    homepage = "https://github.com/mjschultz/py-radix";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ marcel ];
  };
})
