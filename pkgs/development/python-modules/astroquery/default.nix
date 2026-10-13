{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  astropy,
  boto3,
  requests,
  keyring,
  beautifulsoup4,
  html5lib,
  matplotlib,
  pillow,
  pkg-resources-backport,
  pytest,
  pytest-astropy,
  pytest-dependency,
  pytest-rerunfailures,
  pytest-timeout,
  pytestCheckHook,
  pyvo,
  astropy-helpers,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astroquery";
    tag = "v${version}";
    hash = "sha256-BcdRBPnJfuW17p31xUhjBmP7Lv98CnmOTCO4aU0xpMM=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "auto_use = True" "auto_use = False"
    filterwarnings_old=$(printf 'filterwarnings =\n    error')
    filterwarnings_new=$(printf 'filterwarnings =\n    error\n    ignore:astropy.samp.*deprecated:Warning')
    substituteInPlace setup.cfg \
      --replace-fail "$filterwarnings_old" "$filterwarnings_new"
  '';

  build-system = [
    astropy-helpers
    pkg-resources-backport
    setuptools
  ];

  dependencies = [
    astropy
    requests
    keyring
    beautifulsoup4
    html5lib
    pyvo
  ];

  nativeCheckInputs = [
    boto3
    matplotlib
    pillow
    pytest
    pytest-astropy
    pytest-dependency
    pytest-rerunfailures
    pytest-timeout
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Tests must be run in the build directory.
  preCheck = ''
    cd build/lib
  '';

  pytestFlags = [
    "--import-mode=importlib"
    "-W"
    "ignore::pytest.PytestRemovedIn10Warning"
  ];

  pythonImportsCheck = [ "astroquery" ];

  meta = {
    changelog = "https://github.com/astropy/astroquery/releases/tag/${src.tag}";
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.smaret ];
  };
}
