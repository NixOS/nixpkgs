{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "func-timeout";
  version = "4.3.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "func_timeout";
    inherit version;
    hash = "sha256-dM08Qo7JT07fuoH5svFJBIRtX/zMJ8kkM7i1k5tVdd0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "func_timeout" ];

  meta = with lib; {
    description = "Allows you to specify timeouts when calling any existing function. Also provides support for stoppable-threads";
    homepage = "https://github.com/kata198/func_timeout";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
  };
}
