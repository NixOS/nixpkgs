{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "progressbar33";
  version = "2.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "1zvf6zs5hzrc03p9nfs4p16vhilqikycvv1yk0pxn8s07fdhvzji";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/progressbar33/";
    description = "Text progressbar library for python";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ twey ];
  };
})
