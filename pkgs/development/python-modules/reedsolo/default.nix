{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "reedsolo";
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09q15ji9iac3nmmxrcdvz8ynldvvqanqy3hs6q3cp327hgf5rcmq";
  };

  meta = with stdenv.lib; {
    description = "A pure-python universal errors-and-erasures Reed-Solomon Codec";
    homepage = "https://github.com/tomerfiliba/reedsolomon";
    license = licenses.publicDomain;
  };
}
