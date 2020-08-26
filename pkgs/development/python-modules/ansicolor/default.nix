{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansicolor";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d17e1b07b9dd7ded31699fbca53ae6cd373584f9b6dcbc124d1f321ebad31f1d";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/numerodix/ansicolor/";
    description = "A library to produce ansi color output and colored highlighting and diffing";
    license = licenses.asl20;
    maintainers = with maintainers; [ andsild ];
  };
}
