{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "vunnel";
  version = "0.55.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "vunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D3f+r+FGcdetE8kwSddVRE9qQ+LiwUHaJaUqUS086cs=";
    leaveDotGit = true;
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
    hatchling
    uv-dynamic-versioning
  ];

  dependencies =
    with python3.pkgs;
    [
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
      oras
      orjson
      packageurl-python
      pytest-snapshot
      python-dateutil
      pyyaml
      requests
      sqlalchemy
      xsdata
      xxhash
      yardstick
      zstandard
    ]
    ++ xsdata.optional-dependencies.cli
    ++ xsdata.optional-dependencies.lxml
    ++ xsdata.optional-dependencies.soap;

  nativeCheckInputs = [
    git
  ]
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
    # Test require network access
    "test_rhel_provider_supports_ignore_hydra_errors"
  ];

  meta = {
    description = "Tool for collecting vulnerability data from various sources";
    homepage = "https://github.com/anchore/vunnel";
    changelog = "https://github.com/anchore/vunnel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vunnel";
  };
})
