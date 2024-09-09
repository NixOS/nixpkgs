{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  astropy,
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
  isPy3k,
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.4.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BH+6ywpPrsTNtiZ16RnCRMHDXmYQRPy7bJqTMzF0fsk=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    astropy
    requests
    keyring
    beautifulsoup4
    html5lib
    pyvo
  ];

  nativeBuildInputs = [
    astropy-helpers
    setuptools
  ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    matplotlib
    pillow
    pytest
    pytest-astropy
    pytest-dependency
    pytest-rerunfailures
  ];

  pytestFlagsArray = [
    # DeprecationWarning: 'cgi' is deprecated and slated for removal in Python 3.13
    "-W"
    "ignore::DeprecationWarning"
  ];

  # Tests must be run in the build directory. The tests create files
  # in $HOME/.astropy so we need to set HOME to $TMPDIR.
  preCheck = ''
    export HOME=$TMPDIR
    cd build/lib
  '';

  pythonImportsCheck = [ "astroquery" ];

  meta = with pkgs.lib; {
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
