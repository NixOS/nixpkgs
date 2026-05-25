{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "parameter-expansion-patched";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/128ifveWC8zNlYtGWtxB3HpK6p7bVk1ahSwhaC2dAs=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "parameter_expansion" ];

  meta = {
    description = "POSIX parameter expansion in Python";
    homepage = "https://github.com/nexB/parameter_expansion_patched";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
