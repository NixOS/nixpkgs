{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylatexenc";
  version = "2.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "phfaist";
    repo = "pylatexenc";
    rev = "v${version}";
    hash = "sha256-3Ho04qrmCtmmrR+BUJNbtdCZcK7lXhUGJjm4yfCTUkM=";
  };

  pythonImportsCheck = [ "pylatexenc" ];
  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Simple LaTeX parser providing latex-to-unicode and unicode-to-latex conversion";
    homepage = "https://pylatexenc.readthedocs.io";
    downloadPage = "https://www.github.com/phfaist/pylatexenc/releases";
    changelog = "https://pylatexenc.readthedocs.io/en/latest/changes/";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
