{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  cython,
  oldest-supported-numpy,

  requests,
  decorator,
  natsort,
  numpy,
  pandas,
  scipy,
  h5py,
  biom-format,
  statsmodels,
  patsy,
  array-api-compat,

  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scikit-bio";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-bio";
    repo = "scikit-bio";
    tag = version;
    hash = "sha256-M0P5DUAMlRTkaIPbxSvO99N3y5eTrkg4NMlkIpGr4/g=";
  };

  build-system = [
    setuptools
    cython
    oldest-supported-numpy
  ];

  dependencies = [
    requests
    decorator
    natsort
    numpy
    pandas
    scipy
    h5py
    biom-format
    statsmodels
    patsy
    array-api-compat
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # only the $out dir contains the built cython extensions, so we run the tests inside there
  enabledTestPaths = [ "${placeholder "out"}/${python.sitePackages}/skbio" ];

  pythonImportsCheck = [ "skbio" ];

  meta = {
    homepage = "http://scikit-bio.org/";
    description = "Data structures, algorithms and educational resources for bioinformatics";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
