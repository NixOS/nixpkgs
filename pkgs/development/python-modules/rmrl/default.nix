{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pdfrw
, reportlab
, setuptools
, svglib
, xdg
}:

buildPythonPackage rec {
  pname = "rmrl";
  version = "unstable-2022-12-11";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "naturale0";
    repo = "rmrl";
    rev = "3c908536f11dfa92f81e7127ae76f18f0b2cc3e3";
    hash = "sha256-13pMfRe2McWDpBTlJy/TBT0W5wyd0EXDoocxeIzmqCo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pdfrw
    reportlab
    setuptools
    svglib
    xdg
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "rmrl" ];

  meta = {
    description = "Render reMarkable documents to PDF";
    homepage = "https://github.com/naturale0/rmrl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
