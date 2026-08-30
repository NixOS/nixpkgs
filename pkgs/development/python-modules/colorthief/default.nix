{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
}:

buildPythonPackage rec {
  pname = "colorthief";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fengsp";
    repo = "color-thief-py";
    rev = version;
    hash = "sha256-FQrFDHj9VaAG4J0PhqwWDhMBftHaK3gmkQvHQBV191M=";
  };

  propagatedBuildInputs = [ pillow ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "colorthief" ];

  meta = {
    description = "Python module for grabbing the color palette from an image";
    homepage = "https://github.com/fengsp/color-thief-py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
