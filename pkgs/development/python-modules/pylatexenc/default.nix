{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylatexenc";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "phfaist";
    repo = "pylatexenc";
    rev = "v${version}";
    sha256 = "1hpcwbknfah3mky2m4asw15b9qdvv4k5ni0js764n1jpi83m1zgk";
  };

  pythonImportsCheck = [ "pylatexenc" ];
  dontUseSetuptoolsCheck = true;
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Simple LaTeX parser providing latex-to-unicode and unicode-to-latex conversion";
    homepage = "https://pylatexenc.readthedocs.io";
    downloadPage = "https://www.github.com/phfaist/pylatexenc/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
