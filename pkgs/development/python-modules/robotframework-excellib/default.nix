{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  openpyxl,
  robotframework,
}:

buildPythonPackage rec {
  pname = "robotframework-excellib";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZzAwlYM8DgWD1hfWRnY8u2RnZc3V368kgigBApeDZYg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    openpyxl
    robotframework
  ];

  pythonImportsCheck = [ "ExcelLibrary" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Robot Framework library for working with Excel documents";
    homepage = "https://github.com/peterservice-rnd/robotframework-excellib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
