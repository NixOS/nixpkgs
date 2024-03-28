{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, colorama
}:

buildPythonPackage rec {
  pname = "pdiff";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkouevda";
    repo = "pdiff";
    rev = "v${version}";
    hash = "sha256-Ek+hWkLfbOnVQvSQ7qSLoZdhXARn5Iz/kmXlFToG2GU=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    colorama
  ];

  pythonImportsCheck = [ "pdiff" ];

  meta = with lib; {
    description = "Pretty side-by-side diff";
    homepage = "https://github.com/nkouevda/pdiff";
    license = licenses.mit;
    maintainers = with maintainers; [ edmundmiller ];
  };
}
