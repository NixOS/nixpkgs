{ lib, buildPythonPackage, fetchPypi, six, chardet, nose
, django, jinja2, tornado, pyramid, pyramid_mako, Mako }:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.9.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yXS+g9VUpicFMLM9GYVcLVSXXQKyyDDcNjX2Y7XvYEI=";
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
