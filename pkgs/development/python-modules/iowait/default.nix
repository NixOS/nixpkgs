{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "iowait";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qxvC64TCLM9h8XoAJPn7bfeBs58YUnZKZqd2nVrfspk=";
  };

  meta = {
    description = "Platform-independent module for I/O completion events";
    homepage = "https://launchpad.net/python-iowait";
    license = lib.licenses.lgpl3Only;
  };
})
