{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "scikit-hep-testdata";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "scikit-hep-testdata";
    tag = "v${version}";
    hash = "sha256-RA/A8av/KXVimktrjU4lHHMw+SokS7niB6zWhgZ4+IQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    pyyaml
    requests
  ];

  env.SKHEP_DATA = 1; # install the actual root files

  doCheck = false; # tests require networking

  pythonImportsCheck = [ "skhep_testdata" ];

  meta = {
    homepage = "https://github.com/scikit-hep/scikit-hep-testdata";
    description = "Common package to provide example files (e.g., ROOT) for testing and developing packages against";
    changelog = "https://github.com/scikit-hep/scikit-hep-testdata/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
