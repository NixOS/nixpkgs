{ lib, python3, fetchFromGitHub, }:

python3.pkgs.buildPythonPackage rec {
  pname = "pynpm";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "pynpm";
    rev = "v${version}";
    hash = "sha256-GjfylyxPZrRGCLuNZejmTdQGz5JugKHYpVix8WF/8QI=";
  };

  nativeBuildInputs =
    [ python3.pkgs.babel python3.pkgs.setuptools python3.pkgs.wheel ];

  pythonImportsCheck = [ "pynpm" ];

  meta = with lib; {
    description = "Python interface to your NPM and package.json";
    homepage = "https://github.com/inveniosoftware/pynpm";
    changelog =
      "https://github.com/inveniosoftware/pynpm/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "pynpm";
  };
}
