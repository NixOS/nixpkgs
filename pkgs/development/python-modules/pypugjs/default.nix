{ lib, buildPythonPackage, fetchPypi, six, chardet, nose
, django, jinja2, tornado, pyramid, pyramid_mako, Mako }:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s0a239940z6rsssa13yz6pfkjk4300j35hs7qysyz45f3ixq19j";
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
