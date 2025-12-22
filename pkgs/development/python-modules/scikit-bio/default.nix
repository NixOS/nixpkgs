{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  cython,
  oldest-supported-numpy,

  # dependencies
  array-api-compat,
  biom-format,
  decorator,
  h5py,
  natsort,
  numpy,
  pandas,
  patsy,
  requests,
  scipy,
  statsmodels,

  # tests
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "scikit-bio";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-bio";
    repo = "scikit-bio";
    tag = version;
    hash = "sha256-TKMbOG5XPUxTy7sW5fE2t7UyavpKp6Y9lbkjE5nFm7o=";
  };

  build-system = [
    setuptools
    cython
    oldest-supported-numpy
  ];

  dependencies = [
    array-api-compat
    biom-format
    decorator
    h5py
    natsort
    numpy
    pandas
    patsy
    requests
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # only the $out dir contains the built cython extensions, so we run the tests inside there
  enabledTestPaths = [ "${placeholder "out"}/${python.sitePackages}/skbio" ];

  # The trick above makes test collection fail on darwin:
  # PermissionError: [Errno 1] Operation not permitted: '/nix/.Trashes'
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "skbio" ];

  meta = {
    description = "Data structures, algorithms and educational resources for bioinformatics";
    homepage = "http://scikit-bio.org/";
    downloadPage = "https://github.com/scikit-bio/scikit-bio";
    changelog = "https://github.com/scikit-bio/scikit-bio/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
