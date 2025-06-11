{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "python-editor";
  version = "1.0.4-unstable-2023-10-11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fmoo";
    repo = "python-editor";
    rev = "c6cd09069371781b2b9381839849a524d25db07f";
    hash = "sha256-TjfY7ustZaNPmndHPVwmQ8zkYPmDs/C5SNJl1zXjprc=";
  };

  # No proper tests
  doCheck = false;

  meta = with lib; {
    description = "Library that provides the `editor` module for programmatically";
    homepage = "https://github.com/fmoo/python-editor";
    license = licenses.asl20;
  };
}
