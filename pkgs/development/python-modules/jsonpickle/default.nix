{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "625098cc8e5854b8c23b587aec33bc8e33e0e597636bfaca76152249c78fe5c1";
  };

  doCheck = false;

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = http://jsonpickle.github.io/;
    license = lib.licenses.bsd3;
  };

}