{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cstruct";
  version = "6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andreax79";
    repo = "python-cstruct";
    tag = "v${version}";
    hash = "sha256-jLpuvApEP8Acva/OV3ulwl4+dOy8t/cD/LFJWWnD3BM=";
  };

  pythonImportsCheck = [ "cstruct" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "C-style structs for Python";
    homepage = "https://github.com/andreax79/python-cstruct";
    changelog = "https://github.com/andreax79/python-cstruct/blob/${src.tag}/changelog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tnias ];
  };
}
