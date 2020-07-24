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
, mock
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5461add4e3f35a7ee377b3d7f72ff13e93f40f3823b3208ab978b29bde936ff";
  };

  propagatedBuildInputs = [ singledispatch logutils ];
  buildInputs = [
    webtest Mako genshi Kajiki sqlalchemy gunicorn jinja2 virtualenv
  ];

  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Pecan";
    homepage = "https://github.com/pecan/pecan";
  };
}
