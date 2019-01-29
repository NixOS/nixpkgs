{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afcf31443a478c32bbac4b00337ee9026a13d0e2ac83d30c79151462513bb0d4";
  };

  meta = with stdenv.lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
  };

}
