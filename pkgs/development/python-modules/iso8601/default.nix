{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7dec22af52025d4526be94cc1303c7d8f5379b746a3f54a8c8446384392eeb1";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test iso8601
  '';

  meta = {
    homepage = "https://bitbucket.org/micktwomey/pyiso8601/";
    description = "Simple module to parse ISO 8601 dates";
    maintainers = with lib.maintainers; [ phreedom ];
  };
}
