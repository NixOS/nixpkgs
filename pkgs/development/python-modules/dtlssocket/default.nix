{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoconf,
  automake,
  cython,
  pkg-config,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dtlssocket";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Gy+Mt+FYtu8y+J0qvJ9J3PoSSqGxBwzSzoKcKUAN88=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
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
