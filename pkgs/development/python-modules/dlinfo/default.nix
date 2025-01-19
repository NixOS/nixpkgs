{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dlinfo";
  version = "2.0.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iKK8BPUdAbxgTNyescPMC96JBXUyymo+caQfYjVDPhc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dlinfo" ];

  meta = {
    description = "Python wrapper for libc's dlinfo and dyld_find on Mac";
    homepage = "https://github.com/cloudflightio/python-dlinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
