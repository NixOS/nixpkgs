{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  lance-namespace-urllib3-client,
  pyarrow,
  # pylance,
  typing-extensions,

  # optional-dependencies
  # dir
  opendal,
  # glue
  boto3,
  botocore,
  # hive2
  hive-metastore-client,
  thrift,

  # tests
  pylance,
  pytestCheckHook,
  lance-namespace,
}:

buildPythonPackage rec {
  pname = "lance-namespace";
  version = "0.0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance-namespace";
    tag = "v${version}";
    hash = "sha256-KbQ1xXD/+8oOcbhc+dvk68ZF0daWm7In0y0NVsSfp9U=";
  };

  sourceRoot = "${src.name}/python/lance_namespace";

  build-system = [
    hatchling
  ];

  pythonRemoveDeps = [
    "pylance"
  ];
  dependencies = [
    lance-namespace-urllib3-client
    typing-extensions
    # pylance
    pyarrow
  ];

  optional-dependencies = {
    dir = [ opendal ];
    glue = [
      boto3
      botocore
    ];
    hive2 = [
      hive-metastore-client
      thrift
    ];
  };

  pythonImportsCheck = [ "lance_namespace" ];

  nativeCheckInputs = [
    pylance
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  # Tests require pylance, which is a circular dependency
  doCheck = false;

  passthru.tests.pytest = lance-namespace.overridePythonAttrs {
    disabledTests = [
      # AttributeError: 'function' object has no attribute 'write_dataset'
      "test_create_table"
      "test_describe_table"
      "test_drop_table"
      "test_list_tables"

      # RuntimeError: Failed to list tables: Operator.list() got an unexpected keyword argument 'recursive'
      "test_create_empty_table"
      "test_empty_list_tables"

      # lance_namespace.unity.LanceNamespaceException: Failed to drop namespace: BehaviorEnum
      "test_drop_namespace"

      # pydantic_core._pydantic_core.ValidationError: 1 validation error for ListNamespacesResponse namespaces
      "test_list_namespaces_schemas"
      "test_list_namespaces_top_level"
    ];

    doCheck = true;
  };

  meta = {
    description = "Open specification on top of the storage-based Lance table and file format to standardize access to a collection of Lance tables";
    homepage = "https://github.com/lancedb/lance-namespace/tree/main/python/lance_namespace";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
