{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pamela";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65c9389bef7d1bb0b168813b6be21964df32016923aac7515bdf05366acbab6c";
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
