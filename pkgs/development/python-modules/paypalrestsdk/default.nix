{ buildPythonPackage, fetchPypi, httplib2 }:

buildPythonPackage rec {
  pname = "paypalrestsdk";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "117kfipzfahf9ysv414bh1mmm5cc9ck5zb6rhpslx1f8gk3frvd6";
  };

  propagatedBuildInputs = [ httplib2 ];

  meta = {
    homepage = https://developer.paypal.com/;
    description = "Python APIs to create, process and manage payment";
    license = "PayPal SDK License";
  };
}
