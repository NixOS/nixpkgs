{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "celery-types";
  version = "0.23.0";
  pyproject = true;

  src = fetchPypi {
    pname = "celery_types";
    inherit version;
    hash = "sha256-QC7QVVrqPNXh5iSPRjLk8Y7sjtskNRc/nm3AhEn6EB4=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ typing-extensions ];

  doCheck = false;

  meta = {
    description = "PEP-484 stubs for Celery";
    homepage = "https://github.com/sbdchd/celery-types";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
