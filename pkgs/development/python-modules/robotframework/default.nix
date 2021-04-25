{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fa609ceb78f67b1476edce8a7011b16bf3ab41c0fb8c211de6c99955eaf9fde";
    extension = "zip";
  };

  meta = with lib; {
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
