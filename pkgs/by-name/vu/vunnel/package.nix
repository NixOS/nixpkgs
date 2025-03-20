{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vunnel";
  version = "0.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "vunnel";
    tag = "v${version}";
    hash = "sha256-3o4ap8BElDxxg3pohzXz38AQlQbzOPeSc5/OYZg8VFM=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "ijson"
    "importlib-metadata"
    "sqlalchemy"
    "websockets"
    "xsdata"
  ];

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    click
    colorlog
    cvss
    defusedxml
    ijson
    importlib-metadata
    iso8601
    lxml
    mashumaro
    mergedeep
    orjson
    packageurl-python
    pytest-snapshot
    python-dateutil
    pyyaml
    requests
    sqlalchemy
    xsdata
    xxhash
    zstandard
  ];

  nativeCheckInputs =
    [ git ]
    ++ (with python3.pkgs; [
      jsonschema
      pytest-mock
      pytest-unordered
      pytestCheckHook
    ]);

  pythonImportsCheck = [ "vunnel" ];

  disabledTests = [
    # Compare output
    "test_status"
    # TypeError
    "test_parser"
  ];

  meta = with lib; {
    description = "Tool for collecting vulnerability data from various sources";
    homepage = "https://github.com/anchore/vunnel";
    changelog = "https://github.com/anchore/vunnel/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "vunnel";
  };
}
