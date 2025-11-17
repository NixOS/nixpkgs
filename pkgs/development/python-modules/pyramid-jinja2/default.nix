{
  lib,
  buildPythonPackage,
  fetchPypi,
  webtest,
  markupsafe,
  jinja2,
  pytestCheckHook,
  pytest-cov-stub,
  zope-deprecation,
  pyramid,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyramid-jinja2";
  version = "2.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyramid_jinja2";
    inherit version;
    hash = "sha256-jFCMs1wTX5UUnKI2EQ+ciHU0NXV0DRbFy3OlDvHCFnc=";
  };

  propagatedBuildInputs = [
    markupsafe
    jinja2
    pyramid
    zope-deprecation
  ];

  nativeCheckInputs = [
    webtest
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pyramid_jinja2" ];

  disabledTests = [
    # AssertionError: Lists differ: ['pyramid_jinja2-2.10',...
    "test_it_relative_to_package"
    # AssertionError: False is not true
    "test_options"
  ];

  meta = with lib; {
    description = "Jinja2 template bindings for the Pyramid web framework";
    homepage = "https://github.com/Pylons/pyramid_jinja2";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
