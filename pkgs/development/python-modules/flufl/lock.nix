{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  atpublic,
  psutil,
  pytest-cov,
  sybil,
  pdm-pep517,
}:

buildPythonPackage rec {
  pname = "flufl-lock";
  version = "7.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "flufl.lock";
    inherit version;
    hash = "sha256-rxQXKzW7xYaHvQa3DRaT/Y1Iy/D/3n5RphjBSK4kBC0=";
  };

  nativeBuildInputs = [ pdm-pep517 ];
  propagatedBuildInputs = [
    atpublic
    psutil
  ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    sybil
  ];

  # disable code coverage checks for all OS. Upstream does not enforce these
  # checks on Darwin, and code coverage cannot be improved downstream nor is it
  # relevant to the user.
  pytestFlagsArray = [ "--no-cov" ];

  pythonImportsCheck = [ "flufl.lock" ];

  pythonNamespaces = [ "flufl" ];

  meta = with lib; {
    homepage = "https://flufllock.readthedocs.io/";
    description = "NFS-safe file locking with timeouts for POSIX and Windows";
    changelog = "https://gitlab.com/warsaw/flufl.lock/-/blob/${version}/docs/NEWS.rst";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.asl20;
  };
}
