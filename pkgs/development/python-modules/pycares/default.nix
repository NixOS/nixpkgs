{
  lib,
  aiodns,
  buildPythonPackage,
  c-ares,
  cffi,
  fetchPypi,
  idna,
  pythonOlder,
  tornado,
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9HV51Qjy9W7d0WznIEV4KtOxs7Z4CYaZ4rahswcz4cI=";
  };

  buildInputs = [ c-ares ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Python interface for c-ares";
    homepage = "https://github.com/saghul/pycares";
    changelog = "https://github.com/saghul/pycares/releases/tag/pycares-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
