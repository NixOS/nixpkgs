{ stdenv, buildPythonPackage, fetchPypi, click }:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124";
  };

  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
