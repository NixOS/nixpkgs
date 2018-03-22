{ stdenv, buildPythonPackage, fetchPypi, isPyPy }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "cachetools";
  version = "2.0.1";
  disabled = isPyPy;  # a test fails

  src = fetchPypi {
    inherit pname version;
    sha256 = "ede01f2d3cbd6ddc9e35e16c2b0ce011d8bb70ce0dbaf282f5b4df24b213bc5d";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
