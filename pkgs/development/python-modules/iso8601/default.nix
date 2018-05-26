{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "0.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test iso8601
  '';

  meta = {
    homepage = https://bitbucket.org/micktwomey/pyiso8601/;
    description = "Simple module to parse ISO 8601 dates";
    maintainers = with lib.maintainers; [ phreedom ];
  };
}