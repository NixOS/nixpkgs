{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  dill,
  tabulate,
}:

buildPythonPackage rec {
  pname = "pyfunctional";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EntilZha";
    repo = "PyFunctional";
    rev = "refs/tags/v${version}";
    hash = "sha256-utUmHQw7Y5pQJkwuy8CbPnCrAd/esaf0n1Exr/trcRg=";
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
