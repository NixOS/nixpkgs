{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cstruct";
  version = "5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andreax79";
    repo = "python-cstruct";
    tag = "v${version}";
    hash = "sha256-VDJ0k3cOuHjckujf9yD1GVE+UM/Y9rjqhiq+MqGq2eM=";
  };

  pythonImportsCheck = [ "cstruct" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "C-style structs for Python";
    homepage = "https://github.com/andreax79/python-cstruct";
    changelog = "https://github.com/andreax79/python-cstruct/blob/v${version}/changelog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tnias ];
  };
}
