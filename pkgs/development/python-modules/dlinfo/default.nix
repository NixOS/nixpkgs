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
  version = "1.2.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X29DtH86pf4SvTR89Tbcj8pgaMYaCiYOQIvsf260vTg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dlinfo" ];

  meta = {
    description = "Python wrapper for libc's dlinfo and dyld_find on Mac";
    homepage = "https://github.com/cloudflightio/python-dlinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.isDarwin;
  };
}
