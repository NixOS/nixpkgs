{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  pyyaml,
  requests,
  pythonAtLeast,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "scikit-hep-testdata";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "scikit-hep-testdata";
    rev = "refs/tags/v${version}";
    hash = "sha256-FIv3yC5Q3H1RXl0n32YH1UqaZiMuWHNcMPTSKLN+IkA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    pyyaml
    requests
  ] ++ lib.optionals (!pythonAtLeast "3.9") [ importlib-resources ];

  SKHEP_DATA = 1; # install the actual root files

  doCheck = false; # tests require networking

  pythonImportsCheck = [ "skhep_testdata" ];

  meta = {
    homepage = "https://github.com/scikit-hep/scikit-hep-testdata";
    description = "Common package to provide example files (e.g., ROOT) for testing and developing packages against";
    changelog = "https://github.com/scikit-hep/scikit-hep-testdata/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
