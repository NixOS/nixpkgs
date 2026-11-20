{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  poetry-core,
  aioresponses,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-aioresponses";
  version = "0.3.0";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "pytest_aioresponses";
    inherit version;
    hash = "sha256-VnezLfoaNpCLNHUktYZ6qzWsHFzh1JcCRNb2YAm8p7Y=";
  };

  patches = [
    # https://github.com/pheanex/pytest-aioresponses/pull/5
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/pheanex/pytest-aioresponses/commit/05595c1b73a9d9b01179bd434fb7cc57230c9251.patch";
      hash = "sha256-CejYyzAYwsueI0k9O4fcTGC0O8dz0vgE057IrvC5YRo=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aioresponses
  ];

  buildInputs = [
    pytest
  ];

  pythonImportsCheck = [ "pytest_aioresponses" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # test_pytest_aioresponses.py isn't distributed on PyPI
  doCheck = false;

  meta = {
    changelog = "https://github.com/pheanex/pytest-aioresponses/blob/main/Changelog";
    description = "Py.test integration for aioresponses";
    homepage = "https://github.com/pheanex/pytest-aioresponses";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
