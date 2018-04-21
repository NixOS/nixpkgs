{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "545b3bee0d65e1abb4baa1818edcc9ec239aa9f2ffbfde8084d71c056180054f";
  };

  doCheck = false;

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = http://jsonpickle.github.io/;
    license = lib.licenses.bsd3;
  };

}