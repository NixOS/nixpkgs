{ stdenv, buildPythonPackage, fetchPypi, future }:

buildPythonPackage rec {

  pname = "backports.csv";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bed884eeb967c8d6f517dfcf672914324180f1e9ceeb0376fde2c4c32fd7008d";
  };

  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "Backport of Python 3 csv module";
    homepage = https://github.com/ryanhiebert;
    license = licenses.psfl;
  };
}
