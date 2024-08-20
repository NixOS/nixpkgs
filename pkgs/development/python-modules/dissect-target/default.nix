{
  lib,
  stdenv,
  asn1crypto,
  buildPythonPackage,
  defusedxml,
  dissect-btrfs,
  dissect-cim,
  dissect-clfs,
  dissect-cstruct,
  dissect-esedb,
  dissect-etl,
  dissect-eventlog,
  dissect-evidence,
  dissect-extfs,
  dissect-fat,
  dissect-ffs,
  dissect-hypervisor,
  dissect-ntfs,
  dissect-regf,
  dissect-shellitem,
  dissect-sql,
  dissect-thumbcache,
  dissect-util,
  dissect-volume,
  dissect-xfs,
  fetchFromGitHub,
  flow-record,
  fusepy,
  impacket,
  ipython,
  paho-mqtt,
  pycryptodome,
  pytestCheckHook,
  pythonOlder,
  ruamel-yaml,
  setuptools,
  setuptools-scm,
  structlog,
  tomli,
  yara-python,
  zstandard,
}:

buildPythonPackage rec {
  pname = "dissect-target";
  version = "3.18";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.target";
    rev = "refs/tags/${version}";
    hash = "sha256-jR+f4t0QXmm007lrGdMyF9vFa3NW35gZxs7pe9sdjfg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "flow.record~=" "flow.record>="
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    defusedxml
    dissect-cstruct
    dissect-eventlog
    dissect-evidence
    dissect-hypervisor
    dissect-ntfs
    dissect-regf
    dissect-util
    dissect-volume
    flow-record
    structlog
  ];

  passthru.optional-dependencies = {
    full = [
      asn1crypto
      dissect-btrfs
      dissect-cim
      dissect-clfs
      dissect-esedb
      dissect-etl
      dissect-extfs
      dissect-fat
      dissect-ffs
      dissect-shellitem
      dissect-sql
      dissect-thumbcache
      dissect-xfs
      fusepy
      ipython
      pycryptodome
      ruamel-yaml
      yara-python
      zstandard
    ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
    yara = [ yara-python ] ++ passthru.optional-dependencies.full;
    smb = [ impacket ] ++ passthru.optional-dependencies.full;
    mqtt = [ paho-mqtt ] ++ passthru.optional-dependencies.full;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.full;

  pythonImportsCheck = [ "dissect.target" ];

  disabledTests =
    [
      "test_cpio"
      # Test requires rdump
      "test_exec_target_command"
      # Issue with tar file
      "test_dpapi_decrypt_blob"
      "test_md"
      "test_nested_md_lvm"
      "test_notifications_appdb"
      "test_notifications_wpndatabase"
      "test_tar_anonymous_filesystems"
      "test_tar_sensitive_drive_letter"
      # Tests compare dates and times
      "yum"
      # Filesystem access, windows defender tests
      "test_config_tree_plugin"
      "test_defender_quarantine_recovery"
      "test_execute_pipeline"
      "test_keychain_register_keychain_file"
      "test_plugins_child_docker"
      "test_plugins_child_wsl"
      "test_reg_output"
      "test_regflex"
      "test_systemd_basic_syntax"
      "test_target_cli_unicode_argparse"
      "test_target_query"
    ]
    ++
    # test is broken on Darwin
    lib.optional stdenv.hostPlatform.isDarwin "test_fs_attrs_no_os_listxattr";

  disabledTestPaths = [
    # Tests are using Windows paths, missing test files
    "tests/plugins/apps/"
    # ValueError: Invalid Locate file magic. Expected /x00LOCATE02/x00
    "tests/plugins/os/unix/locate/"
    # Missing plugin support
    "tests/tools/test_dump.py"
    "tests/plugins/os/"
    "tests/plugins/filesystem/"
    "tests/test_registration.py"
    "tests/filesystems/"
    "tests/test_filesystem.py"
    "tests/loaders/"
  ];

  meta = with lib; {
    description = "Dissect module that provides a programming API and command line tools";
    homepage = "https://github.com/fox-it/dissect.target";
    changelog = "https://github.com/fox-it/dissect.target/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
