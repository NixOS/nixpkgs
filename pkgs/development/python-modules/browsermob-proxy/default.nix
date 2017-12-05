{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "browsermob-proxy";
  version = "0.8.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bxvmghm834gsfz3pm69772wzhh15p8ci526b25dpk3z4315nd7v";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "A library for interacting with Browsermob Proxy";
    homepage = http://oss.theautomatedtester.co.uk/browsermob-proxy-py;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
