{
  lib,
  aiodns,
  buildPythonPackage,
  c-ares,
  cffi,
  cmake,
  fetchPypi,
  idna,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "5.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WjwknIMEMmMUOYFfmoGEY0FvKoy9semI54dX3prnUIE=";
  };

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  propagatedNativeBuildInputs = [ cffi ];

  build-system = [ setuptools ];

  buildInputs = [ c-ares ];

  dependencies = [ cffi ];

  optional-dependencies.idna = [ idna ];

  # Requires network access
  doCheck = false;

  passthru.tests = {
    inherit aiodns tornado;
  };

  pythonImportsCheck = [ "pycares" ];

  meta = {
    description = "Python interface for c-ares";
    homepage = "https://github.com/saghul/pycares";
    changelog = "https://github.com/saghul/pycares/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
