{ lib
, buildPythonPackage
, fetchPypi
, django
, pillow
, python-magic
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6569d5c3e13c69ab8912ba5100084aa5abcdcffb8d1f5abc085b226e7bbd65b3";
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

