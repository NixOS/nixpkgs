{
  lib,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deap";
  version = "1.4.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fJcIj7BYNb3CVb7EdcsOd43itD5Ey++/K81lWu7IZf0=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
  ];
  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Novel evolutionary computation framework for rapid prototyping and testing of ideas";
    homepage = "https://github.com/DEAP/deap";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Novel evolutionary computation framework for rapid prototyping and testing of ideas";
    homepage = "https://github.com/DEAP/deap";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      getpsyched
      psyanticy
    ];
  };
}
