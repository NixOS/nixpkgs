{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "commandlines";
  version = "0.4.1";
  format = "setuptools";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "commandlines";
    rev = "v${version}";
    hash = "sha256-x3iUeOTAaTKNW5Y5foMPMJcWVxu52uYZoY3Hhe3UvQ4=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Python library for command line argument parsing";
    homepage = "https://github.com/chrissimpkins/commandlines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
=======
  meta = with lib; {
    description = "Python library for command line argument parsing";
    homepage = "https://github.com/chrissimpkins/commandlines";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
