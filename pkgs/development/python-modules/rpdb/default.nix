{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rpdb";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XRoc7jQ3irB1h53DD6YyjUSKn2gKZsToTKxzgq2S8V8=";
  };

  meta = with lib; {
    description = "pdb wrapper with remote access via tcp socket";
    homepage = "https://github.com/tamentis/rpdb";
    license = licenses.bsd2;
  };
}
