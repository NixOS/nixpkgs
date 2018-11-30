{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c878e03c2eff2282e64035bec0a30532b2b1173aadf08486401883b79e4dab1";
  };

  meta = with stdenv.lib; {
    description = "A Python script for summarizing gcov data";
    license = licenses.bsd0;
    homepage = http://gcovr.com/;
  };

}
