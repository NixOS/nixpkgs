{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "jdcal";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ryhy4JbrjfIZwj8mifwzZmi9tD0ZQJS1zBcH4WQKz8g=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Module containing functions for converting between Julian dates and calendar dates";
    homepage = "https://github.com/phn/jdcal";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lihop ];
  };
}
