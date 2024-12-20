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
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ClementJ18";
    repo = "moddb";
    rev = "v${version}";
    hash = "sha256-2t5QQAmSLOrdNCl0XdsFPdP2UF10/qq69DovqeQ1Vt8=";
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
