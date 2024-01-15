{ lib
, buildPythonPackage
, fetchPypi
, django
, pillow
, python-magic
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FlHbLtNthDz7F4jyYBRyopPZuoZyk2m29uVZERI1esc=";
  };
  propagatedBuildInputs = [ pillow python-magic ];

  nativeCheckInputs = [ django ];

  # tests not included with pypi release
  doCheck = false;

  pythonImportsCheck = [ "versatileimagefield" ];

  meta = with lib; {
    description = "Replaces django's ImageField with a more flexible interface";
    homepage = "https://github.com/respondcreate/django-versatileimagefield/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}

