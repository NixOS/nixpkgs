{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "mock-open";
  version = "1.4.0";
  format = "setuptools";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "nivbend";
    repo = "mock-open";
    rev = "v${version}";
    hash = "sha256-dfXYykz1oSCCNXXjUnvdWdqaD3Lp+gEerlZ3LJEnn2I=";
  };

  meta = {
    homepage = "https://github.com/nivbend/mock-open";
    description = "Better mock for file I/O";
    license = lib.licenses.mit;
  };
}
