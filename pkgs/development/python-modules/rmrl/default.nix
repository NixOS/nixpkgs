{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pythonRelaxDepsHook
, pdfrw
, reportlab
, rmscene
, setuptools
, svglib
, xdg
}:

buildPythonPackage rec {
  pname = "rmrl";
  version = "0.2.1-unstable-2023-06-1";

  disabled = pythonOlder "3.10";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "benneti";
    repo = "rmrl";
    rev = "e6f20322c80c6551174da1826c78261dfb3b74fe";
    hash = "sha256-jGWYrw6kcNSb4zhyCjap3l8+YCdOkk5kb5UCiBgW8u0=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "reportlab"
    "rmscene"
    "xdg"
  ];

  propagatedBuildInputs = [
    pdfrw
    reportlab
    rmscene
    setuptools
    svglib
    xdg
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "rmrl" ];

  meta = {
    description = "Render reMarkable documents to PDF";
    homepage = "https://github.com/benneti/rmrl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
