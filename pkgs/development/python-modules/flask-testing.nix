{ stdenv, fetchPypi, buildPythonPackage, pythonOlder
, flask, blinker, twill }:

with stdenv.lib;

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Flask-Testing";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w0dpwvrcpffm8ychyxpm8s5blm7slik9kplh9jb3sgwcv9gyppj";
  };

  postPatch = ''
    sed -i -e 's/twill==0.9.1/twill/' setup.py
  '';

  buildInputs = optionals (pythonOlder "3.0") [ twill ];
  propagatedBuildInputs = [ flask blinker ];

  meta = {
    description = "Flask unittest integration.";
    homepage = https://pythonhosted.org/Flask-Testing/;
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
  };
}
