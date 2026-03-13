{
  lib,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  jinja2,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jinja2-strcase";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2Qw3971A00WqzI94sIf2bmxapMloqyOnkVc/z3VsM3k=";
  };

  build-system = [ setuptools ];

  dependencies = [ jinja2 ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jinja2_strcase" ];

  doCheck = false; # no tests

  meta = {
    homepage = "https://github.com/marchmiel/jinja2-strcase";
    description = "Library for converting string case in Jinja2 templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
}
