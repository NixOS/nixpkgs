{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "bottombar";
  version = "2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "bottombar";
    rev = "refs/tags/v${version}";
    hash = "sha256-W+Cbcgb664nVT/nsFdDruT688JWG2NZnF5hDDezTgnw=";
  };

  nativeBuildInputs = [ flit-core ];

  # The package only has some "interactive" tests where a user must check for
  # the correct output and hit enter after every check
  doCheck = false;
  pythonImportsCheck = [ "bottombar" ];

  meta = with lib; {
    description = "Context manager that prints a status line at the bottom of a terminal window";
    homepage = "https://github.com/evalf/bottombar";
    changelog = "https://github.com/evalf/bottombar/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ conni2461 ];
  };
}
