{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-hosts";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_hosts";
    inherit version;
    hash = "sha256-TFaZHiL2v/woCWgz3nh/kjUOhbfN1ghnBnJcVcTwSrk=";
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
