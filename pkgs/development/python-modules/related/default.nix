{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "related";
  version = "0.7.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IqmbqAW6PubN9GBXrMs5Je4u1XkgLl9camSGNrlrFJA=";
  };

  postPatch = ''
    # Remove outdated setup.cfg
    rm setup.cfg
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""

    # remove dependency on future
    substituteInPlace \
      src/related/dispatchers.py \
      src/related/fields.py \
      tests/ex03_company/test_company.py \
      --replace-fail \
        "from future.moves.urllib.parse import ParseResult" \
        "from urllib.parse import ParseResult"

    substituteInPlace \
      src/related/converters.py \
      --replace-fail \
        "from future.moves.urllib.parse import urlparse" \
        "from urllib.parse import urlparse"
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  dependencies = [
    attrs
    python-dateutil
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Source tarball doesn't contains all needed files
    "test_compose_from_yml"
    "test_yaml_roundtrip_with_empty_values"
    "test_compose_from_yml"
    "test_store_data_from_json"
  ];

  pythonImportsCheck = [ "related" ];

  meta = with lib; {
    description = "Nested Object Models in Python";
    homepage = "https://github.com/genomoncology/related";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
