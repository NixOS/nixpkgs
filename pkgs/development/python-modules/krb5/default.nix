{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  k5test,
  krb5-c, # C krb5 library
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "krb5";
  version = "0.6.0";
  pyproject = true;

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cSugkvvjoo7BiCC7Gx7SzBA3t1xccDP5cMaoyXu9Egk=";
  };

  nativeBuildInputs = [
    cython
    krb5-c
  ];

  nativeCheckInputs = [
    k5test
    pytestCheckHook
  ];

  pythonImportsCheck = [ "krb5" ];

  meta = with lib; {
    description = "Kerberos API bindings for Python";
    homepage = "https://github.com/jborean93/pykrb5";
    license = licenses.mit;
    maintainers = teams.deshaw.members;
  };
}
