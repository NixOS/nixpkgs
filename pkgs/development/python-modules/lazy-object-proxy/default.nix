{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb91be369f945f10d3a49f5f9be8b3d0b93a4c2be8f8a5b83b0571b8123e0a7a";
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
