{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  argcomplete,
  colorama,
  halo,
  platformdirs,
  spinners,
  types-colorama,
  nose2,
  semver,
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    hash = "sha256-Vuc69ikRXpeECqU/22/h3+TmMi0jD0Ik+cVW8e9eWbw=";
  };

  propagatedBuildInputs = [
    argcomplete
    colorama
    halo
    platformdirs
    spinners
    types-colorama
  ];

  nativeCheckInputs = [
    nose2
    semver
  ];

  pythonImportsCheck = [ "milc" ];

  meta = with lib; {
    description = "Opinionated Batteries-Included Python 3 CLI Framework";
    mainProgram = "milc-color";
    homepage = "https://milc.clueboard.co";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
