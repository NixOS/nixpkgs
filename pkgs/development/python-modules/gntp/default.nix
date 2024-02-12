{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "gntp";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q6scs8lp84v0aph6b5c9jhv51rhq2vmzpdd38db92ybkq0g597l";
  };

  pythonImportsCheck = [ "gntp" "gntp.notifier" ];

  # requires a growler service to be running
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kfdm/gntp/";
    description = "Python library for working with the Growl Notification Transport Protocol";
    license = licenses.mit;
    maintainers = [ maintainers.jfroche ];
  };
}
