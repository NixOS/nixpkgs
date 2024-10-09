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

  meta = with lib; {
    description = "Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
    license = licenses.lgpl21Plus;
    inherit (pkgs.attr.meta) platforms;
  };
}
