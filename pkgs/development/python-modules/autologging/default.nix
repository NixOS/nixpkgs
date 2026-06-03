{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "autologging";
  version = "1.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "Autologging";
    inherit (finalAttrs) version;
    hash = "sha256-EXZZWE2Kq4z2IEb2gvjle1TZWLhXHHN/qL8Vwyk3+7Y=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  meta = {
    homepage = "https://ninthtest.info/python-autologging/";
    description = "Easier logging and tracing for Python classes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
  };
})
