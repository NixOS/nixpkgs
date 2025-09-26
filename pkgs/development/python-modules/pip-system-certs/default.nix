{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  git-versioner,
  pip,
}:

buildPythonPackage rec {
  pname = "pip-system-certs";
  version = "5.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pip_system_certs";
    hash = "sha256-gLd2tc8XGRv5nTE2mbf84v24Tre7siX9E0EJqCcGQG8=";
  };

  build-system = [
    setuptools-scm
    git-versioner
  ];

  dependencies = [ pip ];

  pythonImportsCheck = [
    "pip_system_certs.wrapt_requests"
    "pip_system_certs.bootstrap"
  ];

  meta = with lib; {
    description = "Live patches pip and requests to use system certs by default";
    homepage = "https://gitlab.com/alelec/pip-system-certs";
    license = licenses.bsd2;
    maintainers = with maintainers; [ slotThe ];
  };
}
