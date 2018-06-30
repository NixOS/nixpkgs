{ stdenv, fetchPypi, buildPythonPackage, pythonOlder
, flask, blinker, twill }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Testing";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc076623d7d850653a018cb64f500948334c8aeb6b10a5a842bf1bcfb98122bc";
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
