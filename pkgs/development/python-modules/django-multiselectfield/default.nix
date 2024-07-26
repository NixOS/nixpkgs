{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ygra8s394d1szgj7yawlca17q08hygsrzvq2k3k48zvd0awg96h";
  };

  propagatedBuildInputs = [ django ];

  # No tests
  doCheck = false;

  meta = {
    description = "django-multiselectfield";
    homepage = "https://github.com/goinnn/django-multiselectfield";
    license = lib.licenses.lgpl3;
  };
}
