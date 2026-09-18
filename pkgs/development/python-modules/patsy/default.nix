{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  numpy,
  scipy, # optional, allows spline-related features (see patsy's docs)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "patsy";
    tag = "v${version}";
    hash = "sha256-queErA3RdYBxIgOh3f2EfKPixpNfmevxLfNtjzcCCaI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patsy" ];

  meta = {
    changelog = "https://github.com/pydata/patsy/releases/tag/${src.tag}";
    description = "Python package for describing statistical models";
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
