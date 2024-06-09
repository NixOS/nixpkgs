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
    owner = "izar";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MseV1ucDCzSM36zx04g9v5euDX0t74KqUSB4+brHzt8=";
  };

  propagatedBuildInputs = [
    pydal
    graphviz
    pandoc
    plantuml
  ];

  pythonImportsCheck = [ "pytm" ];

  meta = with lib; {
    description = "A Pythonic framework for threat modeling";
    homepage = "https://owasp.org/www-project-pytm/";
    license = with licenses; [
      capec
      mit
    ];
    maintainers = with maintainers; [ wamserma ];
  };
}
