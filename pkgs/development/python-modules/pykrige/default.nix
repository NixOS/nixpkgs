{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  scipy,

  # tests
  gstools,
  pytestCheckHook,
  scikit-learn,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pykrige";
  version = "1.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeoStat-Framework";
    repo = "PyKrige";
    tag = "v${version}";
    hash = "sha256-9f8SNlt4qiTlXgx2ica9Y8rmnYzQ5VarvFRfoZ9bSsY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0rc1,<2.3; python_version >= '3.9'" "numpy>=2.0.0" \
      --replace-fail "Cython>=3.0.10,<3.1.0" "Cython>=3.1.0,<4.0.0"
  '';

  build-system = [
    cython
    numpy
    scipy
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    gstools
    pytestCheckHook
    scikit-learn
    writableTmpDirAsHomeHook
  ];

  # Requires network access
  disabledTests = [
    "test_krige_classification_housing"
    "test_pseudo_2d"
    "test_pseudo_3d"
    "test_krige_housing"
  ];

  meta = {
    description = "Kriging Toolkit for Python";
    homepage = "https://github.com/GeoStat-Framework/PyKrige";
    changelog = "https://github.com/GeoStat-Framework/PyKrige/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sikmir ];
  };
}
