{ stdenv, buildPythonPackage, fetchPypi
, unittest2 }:

buildPythonPackage rec {
  pname = "funcsigs";
  version = "1.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l4g5818ffyfmfs1a924811azhjj8ax9xd1cffr1mzd3ycn0zfx7";
  };

  buildInputs = [ unittest2 ];

  meta = with stdenv.lib; {
    description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
    homepage = https://github.com/aliles/funcsigs;
    maintainers = with maintainers; [ garbas ];
    license = licenses.asl20;
  };
}
