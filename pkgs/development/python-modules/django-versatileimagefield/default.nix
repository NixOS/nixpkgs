{ stdenv
, buildPythonPackage
, fetchPypi
, django
, python
, pillow
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y0r6ssxyg9x1rylpyxg2ha2hl18080k5xp308k4ankpjm50hvc8";
  };
  propagatedBuildInputs = [ pillow ];

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

