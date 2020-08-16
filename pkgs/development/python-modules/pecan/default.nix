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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b2acd6802a04b59e306d0a6ccf37701d24376f4dc044bbbafba3afdf9d3389a";
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
