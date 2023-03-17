{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l8ulFSbIKSgiGP65nasbHmvfjv0cQ9ydV74JPA1pyZo=";
  };

  meta = with lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
  };

}
