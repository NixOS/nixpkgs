{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
   pname = "applicationinsights";
   version = "0.11.9";

   src = fetchPypi {
     inherit pname version;
     sha256 = "1hyjdv6xnswgqvip8y164piwfach9hjkbp7vc2qzhd7amjpim89h";
   };

  meta = with lib; {
    homepage = https://github.com/microsoft/ApplicationInsights-Python;
    description = "This project extends the Application Insights API surface to support Python";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };

 }
