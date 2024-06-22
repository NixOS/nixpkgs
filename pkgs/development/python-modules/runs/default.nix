{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  xmod,
  pytestCheckHook,
  tdir,
}:

buildPythonPackage rec {
  pname = "runs";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "runs";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Run a block of text as a subprocess";
    homepage = "https://github.com/rec/runs";
    changelog = "https://github.com/rec/runs/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
