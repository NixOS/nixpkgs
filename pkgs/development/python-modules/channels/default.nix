{ lib, stdenv, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "056b72e51080a517a0f33a0a30003e03833b551d75394d6636c885d4edb8188f";
  };

  # Files are missing in the distribution
  doCheck = false;

  propagatedBuildInputs = [ asgiref django daphne ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    license = licenses.bsd3;
    homepage = "https://github.com/django/channels";
  };
}
