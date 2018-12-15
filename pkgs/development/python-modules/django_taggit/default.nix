{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "0.17.0";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xy4mm1y6z6bpakw907859wz7fiw7jfm586dj89w0ggdqlb0767b";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "django-taggit is a reusable Django application for simple tagging";
    homepage = https://github.com/alex/django-taggit/tree/master/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
