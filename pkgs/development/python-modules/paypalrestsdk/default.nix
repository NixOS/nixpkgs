{ buildPythonPackage, fetchPypi
, requests, six, pyopenssl }:

buildPythonPackage rec {
  pname = "paypalrestsdk";
  version = "1.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2sI2SSqawSYKdgAUouVqs4sJ2BQylbXollRTWbYf7dY=";
  };

  propagatedBuildInputs = [ requests six pyopenssl ];

  meta = {
    homepage = "https://developer.paypal.com/";
    description = "Python APIs to create, process and manage payment";
    license = "PayPal SDK License";
  };
}
