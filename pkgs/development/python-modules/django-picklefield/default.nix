{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-picklefield";
  name = "${pname}-${version}";
  version = "0.3.2";

  meta = {
    description = "A pickled object field for Django";
    homepage = https://github.com/gintas/django-picklefield;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qlsbp3798ii68ny9zlz2ppkna00jf7i4hmjal3p8433gi18md7s";
  };
}
