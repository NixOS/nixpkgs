{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansicolor";
  version = "0.2.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zlkk9706xn5yshwzdn8xsfkim8iv44zsl6qjwg2f4gn62rqky1h";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/numerodix/ansicolor/;
    description = "A library to produce ansi color output and colored highlighting and diffing";
    license = licenses.asl20;
    maintainers = with maintainers; [ andsild ];
  };
}
