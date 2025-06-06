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
    sha256 = "0fgxjdnvnvavnxmxxd0fl5jyr2f31g3a26bwyxcpy56mgpd095c1";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest tests
  '';

  pythonImportsCheck = [ "pylev" ];

  meta = with lib; {
    description = "Python Levenshtein implementation";
    homepage = "https://github.com/toastdriven/pylev";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
