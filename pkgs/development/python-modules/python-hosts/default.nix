{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-hosts";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XiU6aO6EhFVgj1g7TYMdbgg7IvjkU2DFoiwYikrB13A=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pyyaml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "python_hosts" ];

  disabledTests = [
    # Tests require network access
    "test_import_from_url_counters_for_part_success"
    "test_import_from_url_with_force"
    "test_import_from_url_without_force"
    "test_import_from_url"
  ];

  meta = with lib; {
    description = "Library for managing a hosts file";
    longDescription = ''
      python-hosts is a Python library for managing a hosts file. It enables you to add
      and remove entries, or import them from a file or URL.
    '';
    homepage = "https://github.com/jonhadfield/python-hosts";
    changelog = "https://github.com/jonhadfield/python-hosts/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
