{ lib
, buildPythonPackage
, fetchPypi
, django
, python
, pillow
, python_magic
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e98f7b0abfbf2559d55b08be40911dcc44b6f3437a6c40d81bf66b6914837fdf";
  };
  propagatedBuildInputs = [ pillow python_magic ];

  checkInputs = [ django ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "Replaces django's ImageField with a more flexible interface";
    homepage = "https://github.com/respondcreate/django-versatileimagefield/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}

