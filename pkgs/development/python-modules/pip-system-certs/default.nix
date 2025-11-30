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
  version = "5.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pip_system_certs";
    hash = "sha256-Gci/mVe8zn1pxNvC0LLvE94ZhNU/UKWQEubbutCvZ8Y=";
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
