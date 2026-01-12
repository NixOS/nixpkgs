{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "flatten-dict";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ianlini";
    repo = "flatten-dict";
    rev = version;
    hash = "sha256-uHenKoD4eLm9sMREVuV0BB/oUgh4NMiuj+IWd0hlxNQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flatten_dict" ];

  meta = {
    description = "Module for flattening and unflattening dict-like objects";
    homepage = "https://github.com/ianlini/flatten-dict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
