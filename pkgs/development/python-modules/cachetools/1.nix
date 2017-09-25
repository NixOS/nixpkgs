{ stdenv, buildPythonPackage, fetchPypi, isPyPy }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "cachetools";
  version = "1.1.3";
  disabled = isPyPy;  # a test fails

  src = fetchPypi {
    inherit pname version;
    sha256 = "0js7qx5pa8ibr8487lcf0x3a7w0xml0wa17snd6hjs0857kqhn20";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
