{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "braceexpand";
  version = "0.1.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    sha256 = "01gpcnksnqv6np28i4x8s3wkngawzgs99zvjfia57spa42ykkrg6";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braceexpand" ];

  meta = {
    description = "Bash-style brace expansion for Python";
    homepage = "https://github.com/trendels/braceexpand";
    changelog = "https://github.com/trendels/braceexpand/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      newam
      pbsds
    ];
  };
}
