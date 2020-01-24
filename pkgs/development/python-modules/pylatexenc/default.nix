{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "pylatexenc";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "phfaist";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wnl00y5dl56aw9j4y21kqapraaravbycwfxdmjsbgl11nk4llx9";
  };

  pythonImportsCheck = [ "pylatexenc" ];
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Simple LaTeX parser providing latex-to-unicode and unicode-to-latex conversion";
    homepage = "https://pylatexenc.readthedocs.io";
    downloadPage = "https;//www.github.com/phfaist/pylatexenc";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}