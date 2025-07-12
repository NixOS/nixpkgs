{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  pyrate-limiter,
  requests,
  toolz,
}:

buildPythonPackage rec {
  pname = "moddb";
  version = "0.12.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ClementJ18";
    repo = "moddb";
    rev = "v${version}";
    hash = "sha256-idBja/W9r8iX69Af+x2TZcLpSLy45fC9pmrMKJZ0RsA=";
  };

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
    description = "Python scrapper to access ModDB mods, games and more as objects";
    homepage = "https://github.com/ClementJ18/moddb";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
