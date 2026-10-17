{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # pythonPackages
  pytest,
}:

buildPythonPackage rec {
  pname = "names";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "treyhunner";
    repo = "names";
    rev = version;
    hash = "sha256-IRi093LJNx0jFuOEtXLrlEIqooibOMDxxGMWQFcI1kk=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Generate random names";
    mainProgram = "names";
    homepage = "https://github.com/treyhunner/names";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
