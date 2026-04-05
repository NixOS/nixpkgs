{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "flatdict";
  version = "4.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "flatdict";
    rev = version;
    hash = "sha256-CWsTiCNdIKSQtjpQC07lhZoU1hXT/MGpXdj649x2GlU=";
  };

  pythonImportsCheck = [ "flatdict" ];

  meta = {
    description = "Python module for interacting with nested dicts as a single level dict with delimited keys";
    homepage = "https://github.com/gmr/flatdict";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
