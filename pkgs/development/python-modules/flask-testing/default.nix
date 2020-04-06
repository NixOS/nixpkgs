{ stdenv, fetchPypi, buildPythonPackage, pythonOlder
, flask, blinker, twill }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Testing";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rkkqgmrzmhpv6y1xysqh0ij03xniic8h631yvghksqwxd9vyjfq";
  };

  postPatch = ''
    sed -i -e 's/twill==0.9.1/twill/' setup.py
  '';

  buildInputs = optionals (pythonOlder "3.0") [ twill ];
  propagatedBuildInputs = [ flask blinker ];

  meta = {
    description = "Flask unittest integration.";
    homepage = "https://pythonhosted.org/Flask-Testing/";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
  };
}
