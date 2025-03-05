{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "xpaste";
  version = "1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ossobv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eVnoLG+06UTOkvGhzL/XS4JBrEwbXYZ1fuNTIW7YAfE=";
  };

  propagatedBuildInputs = with python3Packages; [
    xlib
  ];

  # no tests, no python module to import, no version output to check
  doCheck = false;

  meta = with lib; {
    description = "Paste text into X windows that don't work with selections";
    mainProgram = "xpaste";
    homepage = "https://github.com/ossobv/xpaste";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gador ];
  };
}
