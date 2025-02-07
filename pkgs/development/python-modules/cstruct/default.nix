{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cstruct";
  version = "6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andreax79";
    repo = "python-cstruct";
    tag = "v${version}";
    hash = "sha256-+0mov6TkvezDAlu+aFvMhk8yr694KQdVJ20ZjgoePMk=";
  };

  pythonImportsCheck = [ "cstruct" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "C-style structs for Python";
    homepage = "https://github.com/andreax79/python-cstruct";
    changelog = "https://github.com/andreax79/python-cstruct/blob/${src.tag}/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ tnias ];
  };
}
