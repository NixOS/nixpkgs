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
    hash = "sha256-BAygCLBLxZ033ZWRFSR52dSM2nPY8jXplDXQ8WW3KPo=";
  };

  propagatedBuildInputs = [
    html5lib
  ];

  nativeCheckInputs = [
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
