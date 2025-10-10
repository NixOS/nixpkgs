{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  setuptools,
  flake8,
  mock,
  pep8,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flake8-polyfill";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlf1mkqw856vi6782qcglqhaacb23khk9wkcgn55npnjxshhjz4";
  };

  build-system = [ setuptools ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [
    mock
    pep8
    pytestCheckHook
  ];

  patches = [
    # Skip unnecessary tests on Flake8, https://github.com/PyCQA/pep8-naming/pull/181
    (fetchpatch {
      name = "skip-tests.patch";
      url = "https://github.com/PyCQA/flake8-polyfill/commit/3cf414350e82ceb835ca2edbd5d5967d33e9ff35.patch";
      sha256 = "mElZafodq8dF3wLO/LOqwFb7eLMsPLlEjNSu5AWqets=";
    })
  ];

  postPatch = ''
    # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
    substituteInPlace setup.cfg \
      --replace-fail pytest 'tool:pytest'
  '';

  pythonImportsCheck = [ "flake8_polyfill" ];

  meta = with lib; {
    homepage = "https://gitlab.com/pycqa/flake8-polyfill";
    description = "Polyfill package for Flake8 plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
