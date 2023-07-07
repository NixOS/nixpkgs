{ lib, buildPythonPackage, fetchPypi, flask, pytest }:

buildPythonPackage rec {
  pname = "Flask-Script";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r8w2v89nj6b9p91p495cga5m72a673l2wc0hp0zqk05j4yrc9b4";
  };

  propagatedBuildInputs = [ flask ];
  nativeCheckInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/smurfix/flask-script";
    description = "Scripting support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
