{ lib, buildPythonPackage, fetchPypi, flask, blinker, nose }:

buildPythonPackage rec {
  pname = "flask-principal";
  version = "0.4.0";

  src = fetchPypi {
    pname = "Flask-Principal";
    inherit version;
    hash = "sha256-9dYTS1yuv9u4bzLVbRjuRLCAh2onJpVgqW6jX3XJlFM=";
  };

  propagatedBuildInputs = [ flask blinker ];

  nativeCheckInputs = [ nose ];

  meta = with lib; {
    homepage = "http://packages.python.org/Flask-Principal/";
    description = "Identity management for flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
