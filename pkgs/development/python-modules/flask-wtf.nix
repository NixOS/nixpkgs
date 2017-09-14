{ stdenv, fetchurl, buildPythonPackage, flask, wtforms, nose }:

buildPythonPackage rec {
  pname = "Flask-WTF";
  version = "0.14.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/F/Flask-WTF/${name}.tar.gz";
    sha256 = "0dncc5as2k61b28k8kal5yh3prmv7zya1jz7kvci7ximzmfda52x";
  };

  propagatedBuildInputs = [ flask wtforms nose ];

  doCheck = false; # requires external service

  meta = with stdenv.lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
    homepage = https://github.com/lepture/flask-wtf/;
  };
}
