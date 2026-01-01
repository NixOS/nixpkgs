{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
<<<<<<< HEAD
  setuptools,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "pyupgrade";
<<<<<<< HEAD
  version = "3.21.2";
  pyproject = true;
=======
  version = "3.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "pyupgrade";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-u4iudzPhVuAOS9cL3z6FCVpWKJZHg7UGpe9aHnN7Byc=";
  };

  build-system = [ setuptools ];

  dependencies = [ tokenize-rt ];
=======
    hash = "sha256-8nvA0uN+j9lkACcNohfthW9lKfI9GIxLEwtJ+3lCYV0=";
  };

  propagatedBuildInputs = [ tokenize-rt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyupgrade" ];

<<<<<<< HEAD
  meta = {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    mainProgram = "pyupgrade";
    homepage = "https://github.com/asottile/pyupgrade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
=======
  meta = with lib; {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    mainProgram = "pyupgrade";
    homepage = "https://github.com/asottile/pyupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
