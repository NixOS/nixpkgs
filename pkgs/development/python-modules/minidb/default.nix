{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "minidb";
    rev = "refs/tags/${version}";
    hash = "sha256-e7wVR+xr+5phNoRnGIxnmrjB1QU9JmyfQiu88PYapA8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "minidb" ];

  meta = with lib; {
    description = "SQLite3-based store for Python objects";
    homepage = "https://thp.io/2010/minidb/";
    license = licenses.isc;
    maintainers = with maintainers; [ tv ];
  };
}
