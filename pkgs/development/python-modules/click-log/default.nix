{ stdenv, buildPythonPackage, fetchPypi, click }:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r1x85023cslb2pwldd089jjk573mk3w78cnashs77wrx7yz8fj9";
  };

  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    homepage = https://github.com/click-contrib/click-log/;
    description = "Logging integration for Click";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
