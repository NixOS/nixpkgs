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
  version = "0.1.19";

  format = "pyproject";

  src = fetchPypi {
    pname = "DTLSSocket";
    inherit version;
    hash = "sha256-hKwWkQ/K+FTgn2Gs8Pynz/ihuVeO8grqekPPbGK5eDI=";
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
