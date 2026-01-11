{
  lib,
  fetchPypi,
  buildPythonPackage,
  ply,
  isPy3k,
}:
buildPythonPackage rec {
  pname = "plyplus";
  version = "0.7.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "PlyPlus";
    inherit version;
    sha256 = "0g3flgfm3jpb2d8v9z0qmbwca5gxdqr10cs3zvlfhv5cs06ahpnp";
  };

  propagatedBuildInputs = [ ply ];

  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/erezsh/plyplus";
    description = "General-purpose parser built on top of PLY";
    maintainers = with lib.maintainers; [ twey ];
    license = lib.licenses.mit;
  };
}
