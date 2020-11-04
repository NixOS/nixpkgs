{ stdenv, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "523d54dcf1b66152c1b658f914f00ed3b518a3432a9decd4898738ca8dbbe10f";
  };

  propagatedBuildInputs = [
    django-picklefield arrow blessed django future
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A multiprocessing distributed task queue for Django";
    homepage = "https://django-q.readthedocs.org";
    license = licenses.mit;
  };
}
