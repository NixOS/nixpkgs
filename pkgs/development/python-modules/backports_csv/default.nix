{ stdenv, buildPythonPackage, fetchPypi, future }:

buildPythonPackage rec {

  pname = "backports.csv";
  version = "1.0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1imzbrradkfn8s2m1qcimyn74dn1mz2p3j381jljn166rf2i6hlc";
  };

  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "Backport of Python 3 csv module";
    homepage = https://github.com/ryanhiebert;
    license = licenses.psfl;
  };
}
