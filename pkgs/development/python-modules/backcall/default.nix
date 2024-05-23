{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "backcall";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Specifications for callback functions passed in to an API";
    homepage = "https://github.com/takluyver/backcall";
    license = lib.licenses.bsd3;
  };
}
