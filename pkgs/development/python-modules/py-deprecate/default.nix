{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  scikit-learn,
}:

let
  pname = "py-deprecate";
  version = "0.3.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Borda";
    repo = "pyDeprecate";
    rev = "v${version}";
    hash = "sha256-84RmQvLxwtLPQk3hX7Q6eeJeejhrO3t+mc95W1E85Fg=";
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
