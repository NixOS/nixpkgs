{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  docutils,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "amply";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YUIRA8z44QZnFxFf55F2ENgx1VHGjTGhEIdqW2x4rqQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    docutils
    pyparsing
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amply" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/willu47/amply";
    description = ''
      Allows you to load and manipulate AMPL/GLPK data as Python data structures
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ ris ];
    license = lib.licenses.epl10;
=======
    maintainers = with maintainers; [ ris ];
    license = licenses.epl10;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
