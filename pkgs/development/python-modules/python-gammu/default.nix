{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  #, pytestCheckHook
  pkg-config,
  gammu,
}:

buildPythonPackage rec {
  pname = "python-gammu";
  version = "3.2.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "python-gammu";
    rev = version;
    hash = "sha256-lFQBrKWwdvUScwsBva08izZVeVDn1u+ldzixtL9YTpA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gammu ];

  # Check with the next release if tests could be run with pytest
  # nativeCheckInputs = [ pytestCheckHook ];
  # Don't run tests for now
  doCheck = false;

  pythonImportsCheck = [ "gammu" ];

  meta = {
    description = "Python bindings for Gammu";
    homepage = "https://github.com/gammu/python-gammu/";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
