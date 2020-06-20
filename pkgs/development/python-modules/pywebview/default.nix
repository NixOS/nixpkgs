{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pywebview";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "r0x0r";
    repo = "pywebview";
    rev = version;
    sha256 = "0anwm6s0pp7xmgylr4m52v7lw825sdby7fajcl929l099n757gq7";
  };

  # disabled due to error in loading unittest
  # don't know how to make test from: None
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/r0x0r/pywebview";
    description = "Lightweight cross-platform wrapper around a webview.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
