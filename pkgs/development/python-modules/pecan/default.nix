{ stdenv
, fetchPypi
, buildPythonPackage
# Python deps
, singledispatch
, logutils
, webtest
, Mako
, genshi
, Kajiki
, sqlalchemy
, gunicorn
, jinja2
, virtualenv
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24f06cf88a488b75f433e62b33c1c97e4575d0cd91eec9eec841a81cecfd6de3";
  };

  propagatedBuildInputs = [ singledispatch logutils ];
  buildInputs = [
    webtest Mako genshi Kajiki sqlalchemy gunicorn jinja2 virtualenv
  ];

  meta = with stdenv.lib; {
    description = "Pecan";
    homepage = "https://github.com/pecan/pecan";
  };
}
