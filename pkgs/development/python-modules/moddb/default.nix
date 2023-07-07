{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, beautifulsoup4
, pyrate-limiter
, requests
, toolz
}:

buildPythonPackage rec {
  pname = "moddb";
  version = "0.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ClementJ18";
    repo = "moddb";
    rev = "v${version}";
    hash = "sha256-Pl/Wc0CL31+ZLFfy6yUfrZzsECifnEpWVGRHZVaFWG4=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    pyrate-limiter
    requests
    toolz
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "moddb" ];

  doCheck = false; # Tests try to access the internet.


  meta = with lib; {
    description = "A Python scrapper to access ModDB mods, games and more as objects";
    homepage = "https://github.com/ClementJ18/moddb";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
