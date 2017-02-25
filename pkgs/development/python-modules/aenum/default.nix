{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "aenum";
  version = "1.4.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bvn2k53nz99fiwql5fkl0fh7xjw8ama9qzdjp36609mpk05ikl8";
  };

  meta = {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    maintainer = with stdenv.lib.maintainers; [ vrthra ];
    license = with stdenv.lib.licenses; [ bsd3 ];
    homepage = https://bitbucket.org/stoneleaf/aenum;
  };
}
