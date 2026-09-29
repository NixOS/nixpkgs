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
    description = "Easier logging and tracing for Python classes";
    homepage = "https://github.com/mzipay/Autologging";
    changelog = "https://github.com/mzipay/Autologging/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
  };
})
