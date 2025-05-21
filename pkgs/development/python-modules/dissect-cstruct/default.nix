{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-cstruct";
  version = "4.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cstruct";
    tag = version;
    hash = "sha256-Y6maLjugnso3cc9zyiZ/6AdrftYAAImYNBDXPJdTuWc=";
  };

  patches = [
    (fetchpatch {
      name = "fix-test_types_enum.patch";
      url = "https://github.com/fox-it/dissect.cstruct/commit/b6c73136828fc2ae59b51d1f68529002d7c37131.diff";
      hash = "sha256-hicMolFu/qAw9QkOyug4PNm2Do2PxuXNXPB+/JHOaFg=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.cstruct" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for C-like structures";
    homepage = "https://github.com/fox-it/dissect.cstruct";
    changelog = "https://github.com/fox-it/dissect.cstruct/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
