{ lib, buildPythonPackage, fetchPypi, flask, blinker, nose }:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "flask-principal";
  version = "0.4.0";

  src = fetchPypi {
    pname = "Flask-Principal";
    inherit version;
    hash = "sha256-9dYTS1yuv9u4bzLVbRjuRLCAh2onJpVgqW6jX3XJlFM=";
=======
  pname = "Flask-Principal";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lwlr5smz8vfm5h9a9i7da3q1c24xqc6vm9jdywdpgxfbi5i7mpm";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
