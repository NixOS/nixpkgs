{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  cython,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "datrie";
  version = "0.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6gIa1MiovxTginHHhypiKqOZpRD5gSloJQkcfKBDboA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner", ' ""
  '';

  dependencies = [
    setuptools
    wheel
    cython
  ];

  # workaround https://github.com/pytries/datrie/issues/101
  env.CFLAGS = "-Wno-error=incompatible-pointer-types";

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datrie" ];

  meta = {
    description = "Super-fast, efficiently stored Trie for Python";
    homepage = "https://github.com/kmike/datrie";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ lewo ];
  };
}
