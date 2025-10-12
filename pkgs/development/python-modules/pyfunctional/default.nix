{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  dill,
  tabulate,
}:

buildPythonPackage {
  pname = "pyfunctional";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EntilZha";
    repo = "PyFunctional";
    rev = "6ed2e9a8a73d97141a8a7edab25e1aefadc256a3"; # missing tag
    hash = "sha256-u7gcZEeg1exb98aVUOorVhxUHqjX50aPTpE5gR6sONI=";
  };

  build-system = [ poetry-core ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry.masonry.api poetry.core.masonry.api \
      --replace-fail "poetry>=" "poetry-core>="
  '';

  dependencies = [
    dill
    tabulate
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "functional" ];

  meta = {
    description = "Python library for creating data pipelines with chain functional programming";
    homepage = "https://github.com/EntilZha/PyFunctional";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
