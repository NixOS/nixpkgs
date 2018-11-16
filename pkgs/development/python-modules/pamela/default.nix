{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pamela";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ssxbqsshrm8p642g3h6wsq20z1fsqhpdvqdm827gn6dlr38868y";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/pamela.py --replace \
      'find_library("pam")' \
      '"${stdenv.lib.getLib pkgs.pam}/lib/libpam.so"'
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "PAM interface using ctypes";
    homepage = "https://github.com/minrk/pamela";
    license = licenses.mit;
  };

}
