{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools-scm,
  six,
  dnspython,
  legacy-cgi,
  pycountry,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "formencode";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "FormEncode";
    inherit version;
    hash = "sha256-63TSIweKKM8BX6iJZsbjTy0Y11EnMY1lwUS+2a/EJj8=";
  };

  postPatch = ''
    sed -i '/setuptools_scm_git_archive/d' setup.py
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    six
    legacy-cgi
  ];

  nativeCheckInputs = [
    dnspython
    pycountry
    pytestCheckHook
  ];

  disabledTests = [
    # requires network for DNS resolution
    "test_doctests"
    "test_unicode_ascii_subgroup"
  ];

  meta = {
    description = "FormEncode validates and converts nested structures";
    homepage = "http://formencode.org";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
