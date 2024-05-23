{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
}:

buildPythonPackage rec {
  pname = "pamela";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1LE5/mAOGS4Xaio2gFkgemv/oOeHmHmxP0/LoBY0gb4=";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/pamela.py --replace \
      'find_library("pam")' \
      '"${lib.getLib pkgs.pam}/lib/libpam.so"'
  '';

  doCheck = false;

  meta = with lib; {
    description = "PAM interface using ctypes";
    homepage = "https://github.com/minrk/pamela";
    license = licenses.mit;
  };
}
