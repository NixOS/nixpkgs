{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "bpylist2";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "parabolala";
    repo = "bpylist2";
    rev = "ddb89e0b0301c6b298de6469221d99b5fe127b58";
    hash = "sha256-OBwDQZL5++LZgpQM96tmplAh1Pjme3KGSNFTKqKUn00=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "bpylist2" ];
  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--pycodestyle" "" \
      --replace-fail "--pylint --pylint-rcfile=pylint.rc" "" \
      --replace-fail "--mypy" ""
  '';

  meta = {
    description = "Parse and Generate binary plists and NSKeyedArchiver archives";
    license = lib.licenses.mit;
    homepage = "https://github.com/parabolala/bpylist2";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
