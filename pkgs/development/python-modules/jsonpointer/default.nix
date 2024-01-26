{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WFzugrcCEfqeYEO3u4nbbhqklSQ0Dd6K1rYyBuponYg=";
  };

  meta = with lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
  };

}
