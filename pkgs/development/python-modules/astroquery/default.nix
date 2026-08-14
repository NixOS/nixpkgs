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
  pytest,
  pytest-astropy,
  pytest-dependency,
  pytest-rerunfailures,
  pytest-timeout,
  pytestCheckHook,
  pyvo,
  astropy-helpers,
  setuptools_80,
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

  build-system = [
    (astropy-helpers.override { setuptools = setuptools_80; })
    setuptools_80
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
    substituteInPlace setup.cfg --replace-fail "auto_use = True" "auto_use = False"
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
    pytest-timeout
    writableTmpDirAsHomeHook
  ];

  # Tests must be run in the build directory.
  preCheck = ''
    cd build/lib
  '';

  # pytest 9 warns about iterator parameters, which this release promotes to
  # errors via its global filterwarnings setting. This is fixed upstream.
  pytestFlags = [ "-Wignore::pytest.PytestRemovedIn10Warning" ];

  pythonImportsCheck = [ "astroquery" ];

  meta = {
    changelog = "https://github.com/astropy/astroquery/releases/tag/${src.tag}";
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.smaret ];
  };
}
