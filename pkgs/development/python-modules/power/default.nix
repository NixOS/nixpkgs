{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "power";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d7d60ec332acbe3a7d00379b45e39abf650bf7ee311d61da5ab921f52f060f0";
  };

  # Tests can't work because there is no power information available.
  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Cross-platform system power status information";
    homepage = "https://github.com/Kentzo/Power";
    license = licenses.mit;
  };
}
