{
  lib,
  buildPythonPackage,
  fetchPypi,
  pymongo,
}:

buildPythonPackage rec {
  pname = "mongodict";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nv5amfs337m0gbxpjb0585s20rndqfc3mfrzq1iwgnds5gxcrlw";
  };

  propagatedBuildInputs = [ pymongo ];

  meta = with lib; {
    description = "MongoDB-backed Python dict-like interface";
    homepage = "https://github.com/turicas/mongodict/";
    license = licenses.gpl3;
  };
}
