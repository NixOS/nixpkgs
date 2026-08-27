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
  version = "3.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = "python-gammu";
    rev = version;
    hash = "sha256-UnVVnsPOo8tI+xz7GAsaNgC8kqV80u1i3jlwTmfd2Cw=";
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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
