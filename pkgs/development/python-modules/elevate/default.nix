{
  lib,
  fetchPypi,
  buildPythonPackage,
  fetchpatch,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "elevate";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U60Z+h3jAfsd4/h2j7OliUIVcW/ZakdWkMTQ/zsd4gk=";
  };

  patches = [
    (fetchpatch {
      # This is for not calling shell wrappers through Python, which fails.
      url = "https://github.com/rkitover/elevate/commit/148b2bf698203ea39c9fe5d635ecd03cd94051af.patch";
      hash = "sha256-wWyGBKcr9AbbZc0NjfJFSqP+JMIY9cUXR+IF2mX4w88=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "elevate" ];

  meta = {
    description = "Python module for re-launching the current process as super-user";
    homepage = "https://github.com/barneygale/elevate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rkitover ];
  };
}
