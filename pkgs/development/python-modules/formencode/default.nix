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
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4X8WGZ0jLlT2eRIATzrTM827uBoaGhAjis8JurmfkZk=";
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
