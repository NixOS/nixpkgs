{ stdenv, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70081f58c6d78748d8664acbf028fb641687c36df38d3d31e9f1b6fcfac1079f";
  };

  propagatedBuildInputs = [
    django-picklefield arrow blessed django future
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A multiprocessing distributed task queue for Django";
    homepage = https://django-q.readthedocs.org;
    license = licenses.mit;
  };
}
