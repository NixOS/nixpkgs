{ stdenv
, buildPythonPackage
, fetchPypi
, django
, python
, pillow
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8322ee9d7bf5ffa5360990320d2cc2efc7017feff35422636d49f625721edf82";
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

