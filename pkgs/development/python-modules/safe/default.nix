{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  version = "0.4";
  pname = "Safe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2fdac9fe8a9dcf02b438201d6ce0b7be78f85dc6492d03edfb89be2adf489de";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/lepture/safe";
    license = licenses.bsd3;
    description = "Check password strength";
  };
}
