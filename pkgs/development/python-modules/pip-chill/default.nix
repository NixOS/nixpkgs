{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pip,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pip-chill";
  version = "1.0.5";
  pyproject = true;

  src = fetchPypi {
    pname = "pip_chill";
    inherit version;
    hash = "sha256-55vFFKv+FE8u9SKQ9ZZ30nnLBbQIT6n4FLvlzA6gTBw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  preCheck = ''
    substituteInPlace tests/test_pip_chill.py \
      --replace-fail "pip_chill/cli.py" "${placeholder "out"}/bin/pip-chill"
  '';

  pythonImportsCheck = [ "pip_chill" ];

  meta = {
    description = "More relaxed `pip freeze`";
    homepage = "https://github.com/rbanffy/pip-chill";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "pip-chill";
  };
}
