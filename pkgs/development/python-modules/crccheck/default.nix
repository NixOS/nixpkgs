{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  unittestCheckHook,
}:

let
  pname = "crccheck";
  version = "1.3.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "MartinScharrer";
    repo = "crccheck";
    rev = "refs/tags/v${version}";
    hash = "sha256-nujt3RWupvCtk7gORejtSwqqVjW9VwztOVGXBHW9T+k=";
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
