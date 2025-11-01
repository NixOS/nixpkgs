{
  lib,
  fetchPypi,
  buildPythonPackage,
  django,
  pytestCheckHook,
  pytest-django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonfield";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ylOHG8MwiuT0zdw7T5ntXG/Gq7GDL7+0mbxtpWbHDko=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = "export DJANGO_SETTINGS_MODULE=tests.settings";

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Reusable model field that allows you to store validated JSON, automatically handling serialization to and from the database";
    homepage = "https://github.com/rpkilby/jsonfield/";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
