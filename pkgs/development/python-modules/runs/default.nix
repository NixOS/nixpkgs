{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  xmod,
  pytestCheckHook,
  tdir,
}:

buildPythonPackage (finalAttrs: {
  pname = "runs";
  version = "1.2.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "runs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aEamhXr3C+jYDzQGzcmGFyl5oEtovxlNacFM08y0ZEk=";
  };

  build-system = [ poetry-core ];

  dependencies = [ xmod ];

  nativeCheckInputs = [
    pytestCheckHook
    tdir
  ];

  disabledTests = [
    # requires .git directory
    "test_many"
  ];

  pythonImportsCheck = [ "runs" ];

  meta = {
    description = "Run a block of text as a subprocess";
    homepage = "https://github.com/rec/runs";
    changelog = "https://github.com/rec/runs/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
