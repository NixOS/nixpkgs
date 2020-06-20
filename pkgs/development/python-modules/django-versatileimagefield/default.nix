{ stdenv
, buildPythonPackage
, fetchPypi
, django
, python
, pillow
, python_magic
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b197e7066f23bb73b001a61525f2b1cae3dd654bf208a944a7ff5a3fe6107b51";
  };
  propagatedBuildInputs = [ pillow python_magic ];

  checkInputs = [ django ];

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Replaces django's ImageField with a more flexible interface";
    homepage = "https://github.com/respondcreate/django-versatileimagefield/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}

