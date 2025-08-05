{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  unittestCheckHook,
}:

let
  pname = "crccheck";
  version = "1.3.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "MartinScharrer";
    repo = "crccheck";
    tag = "v${version}";
    hash = "sha256-hT+8+moni7turn5MK719b4Xy336htyWWmoMnhgxKkYo=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python library for CRCs and checksums";
    homepage = "https://github.com/MartinScharrer/crccheck";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
