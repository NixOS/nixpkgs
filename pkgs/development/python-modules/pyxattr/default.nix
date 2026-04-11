{
  lib,
  attr,
  fetchPypi,
  stdenv,
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

  buildInputs = lib.optional (lib.meta.availableOn stdenv.buildPlatform attr) attr;

  meta = {
    description = "Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
    license = lib.licenses.lgpl21Plus;
    # Darwin doesn't need `attr` for this.
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
