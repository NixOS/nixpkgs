{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoconf,
  cython_0,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dtlssocket";
  version = "0.1.18";

  format = "pyproject";

  src = fetchPypi {
    pname = "DTLSSocket";
    inherit version;
    hash = "sha256-TnS2LYe6CeAlezc83bGpRqOpQbPJMQHzJn6PnXon4FI=";
  };

  nativeBuildInputs = [
    autoconf
    cython_0
    setuptools
  ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "DTLSSocket" ];

  meta = with lib; {
    description = "Cython wrapper for tinydtls with a Socket like interface";
    homepage = "https://git.fslab.de/jkonra2m/tinydtls-cython";
    license = licenses.epl10;
    maintainers = with maintainers; [ dotlambda ];
  };
}
