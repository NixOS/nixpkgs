{ buildPythonPackage, fetchPypi
, requests, six, pyopenssl }:

buildPythonPackage rec {
  pname = "paypalrestsdk";
  version = "1.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "238713208031e8981bf70b3350b3d7f85ed64d34e0f21e4c1184444a546fee7f";
  };

  propagatedBuildInputs = [ requests six pyopenssl ];

  meta = {
    homepage = "https://developer.paypal.com/";
    description = "Python APIs to create, process and manage payment";
    license = "PayPal SDK License";
  };
}
