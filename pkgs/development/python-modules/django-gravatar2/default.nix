{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-gravatar2";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qsv40xywbqsf4mkrmsswrpzqd7nfljxpfiim9an2z3dykn5rka6";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Essential Gravatar support for Django";
    homepage = https://github.com/twaddington/django-gravatar;
    license = licenses.mit;
  };
}
