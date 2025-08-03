{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multimethod";
  version = "2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coady";
    repo = "multimethod";
    tag = "v${version}";
    hash = "sha256-/91re2K+nVKULJOjDoimpOukQlLlsMS9blkVQWit2eI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multimethod" ];

  meta = with lib; {
    description = "Multiple argument dispatching";
    homepage = "https://coady.github.io/multimethod/";
    changelog = "https://github.com/coady/multimethod/tree/${src.tag}#changes";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
