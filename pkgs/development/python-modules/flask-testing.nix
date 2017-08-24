{ stdenv, fetchPypi, buildPythonPackage, pythonOlder
, flask, blinker, twill }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Testing";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f25effd266fce9b16482f4ce3423d5a7d25534aab77bc83caace5d9637bf0df0";
  };

  buildInputs = optionals (pythonOlder "3.0") [ twill ];
  propagatedBuildInputs = [ flask blinker ];

  meta = {
    description = "Flask unittest integration.";
    homepage = https://pythonhosted.org/Flask-Testing/;
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
  };
}
