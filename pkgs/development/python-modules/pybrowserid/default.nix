{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  unittestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "pybrowserid";
  version = "0.14.0";
  pyproject = true;

  src = fetchPypi {
    pname = "PyBrowserID";
    inherit version;
    hash = "sha256-bCJ2aeh8wleWrnb2oO9lAlUoyK2C01Jnn6mj5WY6ceM=";
  };

  patches = [ ./darwin_fix.patch ];

  postPatch = ''
    substituteInPlace browserid/tests/* \
        --replace-warn 'assertEquals' 'assertEqual'
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "browserid" ];

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];

  meta = with lib; {
    description = "Python library for the BrowserID Protocol";
    homepage = "https://github.com/mozilla/PyBrowserID";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
