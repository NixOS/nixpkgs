{
  lib,
  pkgs,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "pyxattr";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SMV47PjqC9Q1GxdSRw4wGpCjdhx8IfAPlT3PbW+m7lo=";
  };

  # IOError: [Errno 95] Operation not supported (expected)
  doCheck = false;

  buildInputs = with pkgs; [ attr ];

<<<<<<< HEAD
  meta = {
    description = "Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
    license = lib.licenses.lgpl21Plus;
=======
  meta = with lib; {
    description = "Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
    license = licenses.lgpl21Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (pkgs.attr.meta) platforms;
  };
}
