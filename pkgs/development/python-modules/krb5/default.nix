{
  lib,
  stdenv,
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
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ajCPLhfRUcOVsk5q7Hvf9qVv42J6MgQvyG1BI5ipLd0=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ krb5-c ];

  nativeCheckInputs = [
    k5test
    pytestCheckHook
  ];

  pythonImportsCheck = [ "krb5" ];

  meta = with lib; {
    changelog = "https://github.com/jborean93/pykrb5/blob/v${version}/CHANGELOG.md";
    description = "Kerberos API bindings for Python";
    homepage = "https://github.com/jborean93/pykrb5";
    license = licenses.mit;
    maintainers = teams.deshaw.members;
    broken = stdenv.hostPlatform.isDarwin; # TODO: figure out how to build on Darwin
  };
}
