{ buildPythonPackage, fetchPypi
, requests, six, pyopenssl }:

buildPythonPackage rec {
  pname = "paypalrestsdk";
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kZUfNtsw1oW5ceFASYSRo1bPHfjv9xZWYDrKTtcs81o=";
  };

  propagatedBuildInputs = [ requests six pyopenssl ];

  meta = {
    homepage = "https://developer.paypal.com/";
    description = "Python APIs to create, process and manage payment";
    license = "PayPal SDK License";
  };
}
