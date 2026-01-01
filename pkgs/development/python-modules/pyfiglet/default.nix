{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.0.4";
  format = "setuptools";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-25yZQO0b8wSN7/U07VL/La+7ws12ELF7teyh321CeO8=";
  };

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "FIGlet in pure Python";
    mainProgram = "pyfiglet";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ thoughtpolice ];
=======
  meta = with lib; {
    description = "FIGlet in pure Python";
    mainProgram = "pyfiglet";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
