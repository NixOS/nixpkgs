{
  buildPythonPackage,
  pkgs,
  lib,
  hfst,
}:

buildPythonPackage rec {
  pname = "omorfi";
  format = "setuptools";
  inherit (pkgs.omorfi) src version;

  sourceRoot = "${src.name}/src/python";

  propagatedBuildInputs = [ hfst ];

  # Fixes some improper import paths
  patches = [ ./importfix.patch ];

  # Apply patch relative to source/src
  patchFlags = [ "-p3" ];

<<<<<<< HEAD
  meta = {
    description = "Python interface for Omorfi";
    homepage = "https://github.com/flammie/omorfi";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ lurkki ];
=======
  meta = with lib; {
    description = "Python interface for Omorfi";
    homepage = "https://github.com/flammie/omorfi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lurkki ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
