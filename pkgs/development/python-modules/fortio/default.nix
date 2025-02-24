{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  numpy
}:

buildPythonPackage rec {
  pname = "fortio";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "syrte";
    repo = pname;
    rev = "87c9b343abff88df9331423ba918e622b00cccfc";
    hash = "sha256-qI6wkgpzArfaazRbzv2IA6+1UU3QAF/GnCmJUiNDm0Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
     numpy
  ];

  doCheck = true;

  pythonImportsCheck = [ "fortio" ];

  meta = with lib; {
    description = "A Python IO for Fortran unformatted binary files with variable-length records.";
    homepage = "https://github.com/syrte/fortio/";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ mathunje ];
  };
}
