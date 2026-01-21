{
  lib,
  aiodns,
  buildPythonPackage,
  c-ares,
  cffi,
  fetchPypi,
  idna,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "4.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-juSE3bI9vsTYjRTtW21ZLBlg0uk8OF1eUrb61WTYI5U=";
  };

  build-system = [ setuptools ];

  buildInputs = [ c-ares ];

  dependencies = [
    cffi
    idna
  ];

  propagatedNativeBuildInputs = [ cffi ];

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
