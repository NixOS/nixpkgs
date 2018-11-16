{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22ed751a2c63c6cf718674fd7461b1dfc45215bab4751ca32b6c9b8cb2734cb3";
  };

  buildInputs = [ pytest ];
  checkPhase = ''
    py.test tests
  '';

  # Broken tests. Seem to be fixed upstream according to Travis.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fast and thorough lazy object proxy";
    homepage = https://github.com/ionelmc/python-lazy-object-proxy;
    license = with licenses; [ bsd2 ];
  };

}
