{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  astropy,
  boto3,
  requests,
  keyring,
  beautifulsoup4,
  html5lib,
  matplotlib,
  pillow,
  pytest,
  pytest-astropy,
  pytest-dependency,
  pytest-rerunfailures,
  pytestCheckHook,
  pyvo,
  astropy-helpers,
  setuptools,
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astroquery";
    tag = "v${version}";
    hash = "sha256-5pNKV+XNfUQca7WoWboVphXffzyVIHCmfxwr4nBMaEk=";
  };

  patches = [
    # https://github.com/astropy/astroquery/pull/3311
    (fetchpatch2 {
      name = "setuptools-package-index.patch";
      url = "https://github.com/astropy/astroquery/commit/9d43beb4b7bea424d73fff0b602ca90026155519.patch";
      hash = "sha256-3QdOwP1rlWeScGxHT9ZVPmffE7S1XE0cbtnQ8T4bIYw=";
    })
  ];

  build-system = [
    astropy-helpers
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

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    boto3
    matplotlib
    pillow
    pytest
    pytest-astropy
    pytest-dependency
    pytest-rerunfailures
  ];

  pytestFlags = [
    # DeprecationWarning: 'cgi' is deprecated and slated for removal in Python 3.13
    "-Wignore::DeprecationWarning"
  ];

  # Tests must be run in the build directory. The tests create files
  # in $HOME/.astropy so we need to set HOME to $TMPDIR.
  preCheck = ''
    export HOME=$TMPDIR
    cd build/lib
  '';

  pythonImportsCheck = [ "astroquery" ];

  meta = {
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.smaret ];
  };
}
