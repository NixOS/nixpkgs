{ buildPythonPackage
, lib
, fetchPypi
, portalocker
}:

buildPythonPackage rec {
  version = "0.11.9";
  pname = "applicationinsights";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hyjdv6xnswgqvip8y164piwfach9hjkbp7vc2qzhd7amjpim89h";
  };

  propagatedBuildInputs = [ portalocker ];

  meta = with lib; {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = "https://github.com/Microsoft/ApplicationInsights-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
