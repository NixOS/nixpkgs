{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  baize,
  pdm-pep517,
  pydantic,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "kui";
  version = "1.8.1";
  src = fetchFromGitHub {
    owner = "abersheeran";
    repo = "kui";
    tag = "v${version}";
    hash = "sha256-NgjOBIBfXTnsCq8eaD+EgaHkI7i+1NR1Te0e8au6NpU=";
  };

  pyproject = true;

  propagatedBuildInputs = [
    baize
    pdm-pep517
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "kui" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Easy-to-use web framework";
    homepage = "https://kui.aber.sh/";
    license = with lib.licenses; [ asl20 ];
  };
}
