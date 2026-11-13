{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "pylev";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "toastdriven";
    repo = "pylev";
    rev = "v${version}";
    hash = "sha256-gZUE2n3VFH9Z93wZocYLw4nsZaEOtN5rt1ttu22T/Tk=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest tests
  '';

  pythonImportsCheck = [ "pylev" ];

  meta = {
    description = "Python Levenshtein implementation";
    homepage = "https://github.com/toastdriven/pylev";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
}
