{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "matrix-common";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "matrix_common";
    inherit version;
    hash = "sha256-YuEhzM2fJDQXtX7DenbcRK6xmKelxnr9a4J1mS/yq9E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "matrix_common" ];

  meta = {
    description = "Common utilities for Synapse, Sydent and Sygnal";
    homepage = "https://github.com/matrix-org/matrix-python-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sumnerevans ];
  };
}
