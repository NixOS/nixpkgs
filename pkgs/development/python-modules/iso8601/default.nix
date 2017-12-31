{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30";
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