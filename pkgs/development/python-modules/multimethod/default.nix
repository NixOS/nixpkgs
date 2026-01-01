{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "multimethod";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coady";
    repo = "multimethod";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0En3NdLLmS/4bw0I3z9xxKa85tECi1rjmpZyxYuZk3w=";
=======
    hash = "sha256-/91re2K+nVKULJOjDoimpOukQlLlsMS9blkVQWit2eI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multimethod" ];

<<<<<<< HEAD
  meta = {
    description = "Multiple argument dispatching";
    homepage = "https://coady.github.io/multimethod/";
    changelog = "https://github.com/coady/multimethod/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Multiple argument dispatching";
    homepage = "https://coady.github.io/multimethod/";
    changelog = "https://github.com/coady/multimethod/tree/${src.tag}#changes";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
