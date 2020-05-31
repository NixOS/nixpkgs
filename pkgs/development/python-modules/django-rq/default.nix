{ stdenv, fetchPypi, buildPythonPackage, redis, rq, django }:

buildPythonPackage rec {
  pname = "django-rq";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lksnjn3q3f7y72bj2yr8870w28a5b6x0vjnd9nhpq2ah6xfz6pf";
  };

  # test require a running redis rerver, which is something we can't do yet
  doCheck = false;

  propagatedBuildInputs = [ rq django redis ];

  meta = with stdenv.lib; {
    description = "A simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    maintainers = with maintainers; [ winpat ];
    license = licenses.mit;
  };
}

