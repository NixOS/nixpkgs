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
  typing-extensions,
  nose2,
  semver,
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    hash = "sha256-byj2mcDxLl7rZEFjAt/g1kHllnVxiTIQaTMG24GeSVc=";
  };

  propagatedBuildInputs = [
    argcomplete
    colorama
    halo
    platformdirs
    spinners
    types-colorama
    typing-extensions
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
