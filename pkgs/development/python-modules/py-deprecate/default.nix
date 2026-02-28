{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  scikit-learn,
}:

let
  pname = "py-deprecate";
  version = "0.5.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Borda";
    repo = "pyDeprecate";
    tag = "v${version}";
    hash = "sha256-5HmFYNxddMDqBn3EFAd/yUoqWZqmm11HgTuYwp0Gpaw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    scikit-learn
  ];

  pythonImportsCheck = [ "deprecate" ];

  meta = {
    description = "Module for marking deprecated functions or classes and re-routing to the new successors' instance. Used by torchmetrics";
    homepage = "https://borda.github.io/pyDeprecate/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
