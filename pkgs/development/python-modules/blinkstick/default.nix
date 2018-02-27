{ lib, buildPythonPackage, fetchPypi, pyusb }:

buildPythonPackage rec {
  pname = "BlinkStick";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3edf4b83a3fa1a7bd953b452b76542d54285ff6f1145b6e19f9b5438120fa408";
  };

  propagatedBuildInputs = [ pyusb ];

  meta = with lib; {
    description = "Python package to control BlinkStick USB devices";
    homepage = https://pypi.python.org/pypi/BlinkStick/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
