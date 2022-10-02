{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, pdfrw
, reportlab
, svglib
, xdg
}:

buildPythonPackage rec {
  pname = "rmrl";
  version = "0.2.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c532bef4168350e6ab17cf37c6481dc12b6a78e007c073503f082f36215b71c9";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pdfrw
    reportlab
    svglib
    xdg
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "rmrl" ];

  meta = {
    description = "Render reMarkable documents to PDF";
    homepage = "https://github.com/rschroll/rmrl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
