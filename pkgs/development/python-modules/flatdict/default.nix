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
    repo = pname;
    rev = version;
    hash = "sha256-CWsTiCNdIKSQtjpQC07lhZoU1hXT/MGpXdj649x2GlU=";
  };

  pythonImportsCheck = [ "flatdict" ];

  meta = with lib; {
    description = "Python module for interacting with nested dicts as a single level dict with delimited keys";
    homepage = "https://github.com/gmr/flatdict";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
