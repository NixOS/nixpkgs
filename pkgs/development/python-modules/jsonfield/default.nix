{
  lib,
  fetchPypi,
  buildPythonPackage,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "jsonfield";
  version = "3.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yl828cd0m8jsyr4di6hcjdqmi31ijh5vk57mbpfl7p2gmcq8kky";
  };

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
