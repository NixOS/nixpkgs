{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dlinfo";
  version = "1.2.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f6f43b47f3aa5fe12bd347cf536dc8fca6068c61a0a260e408bec7f6eb4bd38";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dlinfo" ];

  meta = {
    description = "Python wrapper for libc's dlinfo and dyld_find on Mac";
    homepage = "https://github.com/cloudflightio/python-dlinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.isDarwin;
  };
}
