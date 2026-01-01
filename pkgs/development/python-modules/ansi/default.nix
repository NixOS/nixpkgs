{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "ansi";
    tag = "ansi-${version}";
    hash = "sha256-PmgB1glksu4roQeZ1o7uilMJNm9xaYqw680N2z+tUUM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "ansi.colour"
    "ansi.color"
  ];

<<<<<<< HEAD
  meta = {
    description = "ANSI cursor movement and graphics";
    homepage = "https://github.com/tehmaze/ansi/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "ANSI cursor movement and graphics";
    homepage = "https://github.com/tehmaze/ansi/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
