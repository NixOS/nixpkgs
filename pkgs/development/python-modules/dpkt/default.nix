{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5737010fd420d142e02ed04fa616edd1fc05e414980baef594f72287c875eef";
  };

  meta = with lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
