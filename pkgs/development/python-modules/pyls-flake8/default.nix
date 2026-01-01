{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flake8,
  python-lsp-server,
  pythonOlder,
}:

<<<<<<< HEAD
buildPythonPackage rec {
=======
buildPythonPackage {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "pyls-flake8";
  version = "0.4.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emanspeaks";
    repo = "pyls-flake8";
<<<<<<< HEAD
    rev = "v${version}";
=======
    rev = "v{version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "14wkmwh8mqr826vdzxhvhdwrnx2akzmnbv3ar391qs4imwqfjx3l";
  };

  propagatedBuildInputs = [
    flake8
    python-lsp-server
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/emanspeaks/pyls-flake8";
    description = "Flake8 plugin for the Python LSP Server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
=======
  meta = with lib; {
    homepage = "https://github.com/emanspeaks/pyls-flake8";
    description = "Flake8 plugin for the Python LSP Server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
