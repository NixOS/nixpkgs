{ lib, fetchPypi, buildPythonPackage, ply, isPy3k }:
buildPythonPackage rec {
  pname = "PlyPlus";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g3flgfm3jpb2d8v9z0qmbwca5gxdqr10cs3zvlfhv5cs06ahpnp";
  };

  propagatedBuildInputs = [ ply ];

  doCheck = !isPy3k;

  meta = {
    homepage = https://github.com/erezsh/plyplus;
    description = "A general-purpose parser built on top of PLY";
    maintainers = with lib.maintainers; [ twey ];
    license = lib.licenses.mit;
  };
}
