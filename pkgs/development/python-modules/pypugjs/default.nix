{ lib, buildPythonPackage, fetchPypi, six, chardet, nose
, django, jinja2, tornado, pyramid, pyramid_mako, Mako }:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kStaT1S8cPJF+iDFk/jLGKi3JVOMmtf7PzeYDKCdD0E=";
  };

  propagatedBuildInputs = [ six chardet ];
  checkInputs = [ nose django jinja2 tornado pyramid pyramid_mako Mako ];

  checkPhase = ''
    nosetests pypugjs
  '';

  meta = with lib; {
    description = "PugJS syntax template adapter for Django, Jinja2, Mako and Tornado templates";
    homepage = "https://github.com/kakulukia/pypugjs";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
