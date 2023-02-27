{ buildPythonPackage, lib, fetchPypi
, requests
, nose
, responses
}:

buildPythonPackage rec {
  pname = "python-forecastio";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m6lf4a46pnwm5xg9dnmwslwzrpnj6d9agw570grciivbvb1ji0l";

  };

  nativeCheckInputs = [ nose ];

  propagatedBuildInputs = [ requests responses ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://zeevgilovitz.com/python-forecast.io/";
    description = "A thin Python Wrapper for the Dark Sky (formerly forecast.io) weather API";
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
