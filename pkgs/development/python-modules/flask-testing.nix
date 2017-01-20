{ stdenv, fetchurl, buildPythonPackage, pythonOlder
, flask, blinker, twill }:

with stdenv.lib;

buildPythonPackage rec {
  name = "Flask-Testing-0.6.1";

  src = fetchurl {
    url = "mirror://pypi/F/Flask-Testing/${name}.tar.gz";
    sha256 = "1ckmy7kz2qkggdlm9y5wx6gvd2x7qv921dyb059ywfh15hrkkxdb";
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
