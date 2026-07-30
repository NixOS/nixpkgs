{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thp";
    repo = "minidb";
    tag = version;
    hash = "sha256-e7wVR+xr+5phNoRnGIxnmrjB1QU9JmyfQiu88PYapA8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "minidb" ];

  meta = {
    description = "SQLite3-based store for Python objects";
    homepage = "https://thp.io/2010/minidb/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ tv ];
  };
}
