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
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TnbXFXJuDEbcCeNdqbZxewY8I4mwbBcj3sw7o4tzh/Q=";
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
