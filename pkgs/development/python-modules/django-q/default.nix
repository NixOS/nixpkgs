{ stdenv, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  name = "${pname}-${version}";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1crlr0xjmfnjvknfdbiy3l0wrnf910jcs3jlh27ks0pi6gbff2qp";
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
