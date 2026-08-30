{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py3dns,
}:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdgathman";
    repo = "pyspf";
    rev = "pyspf-${version}";
    hash = "sha256-sXmOe8xudty98k7Oij0vflgwIOPXRMKkpS/hzCutsS4=";
  };

  propagatedBuildInputs = [ py3dns ];

  # requires /etc/resolv.conf to exist
  doCheck = false;

  meta = {
    homepage = "http://bmsi.com/python/milter.html";
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = [ ];
    license = lib.licenses.gpl2;
  };
}
