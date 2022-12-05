{ lib
, buildPythonPackage
, fetchFromGitHub
, html5lib
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "microdata";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "edsu";
    repo = "microdata";
    rev = "v${version}";
    sha256 = "sha256-BAygCLBLxZ033ZWRFSR52dSM2nPY8jXplDXQ8WW3KPo=";
  };

  propagatedBuildInputs = [
    html5lib
  ];

  checkInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "microdata" ];

  meta = with lib; {
    description = "Library for extracting html microdata";
    homepage = "https://github.com/edsu/microdata";
    license = licenses.cc0;
    maintainers = with maintainers; [ ambroisie ];
  };
}
