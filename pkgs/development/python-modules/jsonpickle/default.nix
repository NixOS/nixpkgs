{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc25dc79571d4ad7db59d05ddb7de0d76a8d598cf6136e1dbeaa9361ebcfe749";
  };

  doCheck = false;

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = http://jsonpickle.github.io/;
    license = lib.licenses.bsd3;
  };

}