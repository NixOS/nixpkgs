{ lib
, attrs
, buildPythonPackage
, fetchPypi
, future
, pytestCheckHook
, python-dateutil
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "related";
  version = "0.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IqmbqAW6PubN9GBXrMs5Je4u1XkgLl9camSGNrlrFJA=";
  };

  propagatedBuildInputs = [
    attrs
    future
    python-dateutil
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Remove outdated setup.cfg
    rm setup.cfg
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  disabledTests = [
    # Source tarball doesn't contains all needed files
    "test_compose_from_yml"
    "test_yaml_roundtrip_with_empty_values"
    "test_compose_from_yml"
    "test_store_data_from_json"
  ];

  pythonImportsCheck = [
    "related"
  ];

  meta = with lib; {
    description = "Nested Object Models in Python";
    homepage = "https://github.com/genomoncology/related";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
