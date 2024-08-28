{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  requests,
  beautifulsoup4,
  colorama,
}:

buildPythonPackage rec {
  pname = "hydra-check";
  version = "1.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fRSC+dfZZSBBeN6YidXRKc1kPUbBKz5OiFSHGOSikgI=";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    colorama
    requests
    beautifulsoup4
  ];

  pythonImportsCheck = [ "hydra_check" ];

  meta = with lib; {
    description = "check hydra for the build status of a package";
    mainProgram = "hydra-check";
    homepage = "https://github.com/nix-community/hydra-check";
    license = licenses.mit;
    maintainers = with maintainers; [
      makefu
      artturin
    ];
  };
}
