{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
  setuptools-scm,
}:

let
  pname = "crccheck";
  version = "1.3.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MartinScharrer";
    repo = "crccheck";
    tag = "v${version}";
    hash = "sha256-hT+8+moni7turn5MK719b4Xy336htyWWmoMnhgxKkYo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python library for CRCs and checksums";
    homepage = "https://github.com/MartinScharrer/crccheck";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
