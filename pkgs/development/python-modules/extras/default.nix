{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "extras";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "132e36de10b9c91d5d4cc620160a476e0468a88f16c9431817a6729611a81b4e";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "Useful extra bits for Python - things that should be in the standard library";
    homepage = "https://github.com/testing-cabal/extras";
    license = lib.licenses.mit;
  };
}
