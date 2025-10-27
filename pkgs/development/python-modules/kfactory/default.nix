{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  aenum,
  cachetools,
  klayout,
  loguru,
  pydantic-extra-types,
  pydantic-settings,
  pydantic,
  pygit2,
  rapidfuzz,
  rectangle-packer,
  requests,
  ruamel-yaml-string,
  scipy,
  semver,
  toolz,
  typer,

  # tests
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kfactory";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "kfactory";
    tag = "v${version}";
    # kfactory uses `.git` to infer the project directory.
    # https://github.com/gdsfactory/kfactory/blob/v2.0.0/src/kfactory/conf.py#L318-L327
    # Otherwise, tests fail with:
    # assert kf.config.project_dir is not None
    # E   AssertionError: assert None is not None
    leaveDotGit = true;
    hash = "sha256-eZRNUb2Qw2HcR2W1pf15ulEt7ZCJwi60SuGdte/cG8E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];
  dependencies = [
    aenum
    cachetools
    klayout
    loguru
    pydantic
    pydantic-extra-types
    pydantic-settings
    pygit2
    rapidfuzz
    rectangle-packer
    requests
    ruamel-yaml-string
    scipy
    semver
    toolz
    typer
  ];

  pythonImportsCheck = [ "kfactory" ];

  nativeCheckInputs = [
    pytest-regressions
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Binary files ... and ... differ
    "test_array"
    "test_array_indexerror"
    "test_autorename"
    "test_cell_default_fallback"
    "test_cell_in_threads"
    "test_cell_yaml"
    "test_circular_snapping"
    "test_create"
    "test_enclosure_name"
    "test_euler_snapping"
    "test_filter_layer_pt_reg"
    "test_filter_regex"
    "test_flatten"
    "test_info"
    "test_invalid_array"
    "test_kcell_attributes"
    "test_namecollision"
    "test_nested_dic"
    "test_nested_dict_list"
    "test_netlist"
    "test_netlist_equivalent"
    "test_no_snap"
    "test_overwrite"
    "test_ports_cell"
    "test_ports_in_cells"
    "test_ports_instance"
    "test_rename_clockwise"
    "test_rename_clockwise_multi"
    "test_schematic_anchor"
    "test_schematic_create"
    "test_schematic_create_cell"
    "test_schematic_kcl_mix_netlist"
    "test_schematic_mirror_connection"
    "test_schematic_route"
    "test_size_info"
    "test_to_dtype"
  ];

  disabledTestPaths = [
    # https://github.com/gdsfactory/kfactory/issues/511
    "tests/test_pdk.py"
    # NameError
    "tests/test_session.py"

    # AssertionError: Binary files ... and ... differ
    "tests/test_all_angle.py"
    "tests/test_cells.py"
    "tests/test_grid.py"
    "tests/test_l2n.py"
    "tests/test_packing.py"
    "tests/test_pins.py"
    "tests/test_rename.py"
    "tests/test_routing.py"
    "tests/test_spiral.py"
  ];

  meta = {
    description = "KLayout API implementation of gdsfactory";
    homepage = "https://github.com/gdsfactory/kfactory";
    changelog = "https://github.com/gdsfactory/kfactory/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
  };
}
