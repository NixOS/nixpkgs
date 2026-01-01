{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonOlder,
  pydal,
  graphviz,
  pandoc,
  plantuml,
}:

buildPythonPackage rec {
  pname = "pytm";
  version = "1.3.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "OWASP";
=======
    owner = "izar";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    repo = "pytm";
    tag = "v${version}";
    sha256 = "sha256-MseV1ucDCzSM36zx04g9v5euDX0t74KqUSB4+brHzt8=";
  };

  propagatedBuildInputs = [
    pydal
    graphviz
    pandoc
    plantuml
  ];

  pythonImportsCheck = [ "pytm" ];

<<<<<<< HEAD
  meta = {
    description = "Pythonic framework for threat modeling";
    homepage = "https://owasp.org/www-project-pytm/";
    license = with lib.licenses; [
      capec
      mit
    ];
    maintainers = with lib.maintainers; [ wamserma ];
=======
  meta = with lib; {
    description = "Pythonic framework for threat modeling";
    homepage = "https://owasp.org/www-project-pytm/";
    license = with licenses; [
      capec
      mit
    ];
    maintainers = with maintainers; [ wamserma ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
