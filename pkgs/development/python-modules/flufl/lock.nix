{
  lib,
  atpublic,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  psutil,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sybil,
}:

buildPythonPackage rec {
  pname = "flufl-lock";
  version = "8.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "flufl_lock";
    inherit version;
    hash = "sha256-FbMzw1+rGjayI4QAVyWK60zXnw+6+CwUTyPN9s8U1eM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    atpublic
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    sybil
  ];

  # disable code coverage checks for all OS. Upstream does not enforce these
  # checks on Darwin, and code coverage cannot be improved downstream nor is it
  # relevant to the user.
  pytestFlags = [ "--no-cov" ];

  pythonImportsCheck = [ "flufl.lock" ];

  pythonNamespaces = [ "flufl" ];

  meta = with lib; {
    description = "NFS-safe file locking with timeouts for POSIX and Windows";
    homepage = "https://flufllock.readthedocs.io/";
    changelog = "https://gitlab.com/warsaw/flufl.lock/-/blob/${version}/docs/NEWS.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ qyliss ];
  };
}
