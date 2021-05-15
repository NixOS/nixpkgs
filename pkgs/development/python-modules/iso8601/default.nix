{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "0.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8aafd56fa0290496c5edbb13c311f78fa3a241f0853540da09d9363eae3ebd79";
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
