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
  version = "9.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "flufl_lock";
    inherit version;
    hash = "sha256-JwpG51SvOTdzXN1Pio9DotxOXECiT9+XL13G2whi6Ls=";
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
