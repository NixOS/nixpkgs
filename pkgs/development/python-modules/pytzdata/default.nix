{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2017.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wi3jh39zsa9iiyyhynhj7w5b2p9wdyd0ppavpsrmf3wxvr7cwz8";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Timezone database for Python";
    homepage = https://github.com/sdispater/pytzdata;
    license = licenses.mit;
  };
}
