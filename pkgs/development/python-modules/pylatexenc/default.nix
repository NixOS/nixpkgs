{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
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

  meta = with lib; {
    description = "Simple LaTeX parser providing latex-to-unicode and unicode-to-latex conversion";
    homepage = "https://pylatexenc.readthedocs.io";
    downloadPage = "https://www.github.com/phfaist/pylatexenc/releases";
    changelog = "https://pylatexenc.readthedocs.io/en/latest/changes/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
