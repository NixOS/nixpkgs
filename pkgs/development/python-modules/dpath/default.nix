{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  nose2,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NPfmMNxV6j8hnlVXJvXaS0sl8iADGcjmkCw5Qljdaj4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    nose2
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dpath" ];

  meta = {
    description = "Python library for accessing and searching dictionaries via /slashed/paths ala xpath";
    homepage = "https://github.com/akesterson/dpath-python";
    changelog = "https://github.com/dpath-maintainers/dpath-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmlb ];
  };
}
