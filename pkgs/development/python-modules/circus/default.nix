{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  psutil,
  pytestCheckHook,
  pythonAtLeast,
  pyyaml,
  pyzmq,
  tornado,
}:

buildPythonPackage rec {
  pname = "circus";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "circus-tent";
    repo = "circus";
    tag = version;
    hash = "sha256-MiZXiGb6F8LAJLAdmEDBO8Y5cJxHJy7jMFi50Ac3Bsc=";
  };

  build-system = [ flit-core ];

  dependencies = [
    psutil
    pyzmq
    tornado
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  # On darwin: Too many open files
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ulimit -n 1024
  '';

  disabledTests = [
    # Depends on the build machine configuration
    "test_resource_watcher_max_mem"
    "test_resource_watcher_min_mem_abs"
    # Compares with magic string
    "test_streams"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # argparse output prefix changed in 3.14
    "test_help_invalid_command"
    # multiprocessing signal handler test times out under 3.14
    "test_handler"
    # tests/venv fixture lacks a python3.14 sitedir
    "test_venv"
    "test_venv_site_packages"
  ];

  pythonImportsCheck = [ "circus" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Process and socket manager";
    homepage = "https://github.com/circus-tent/circus";
    changelog = "https://github.com/circus-tent/circus/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
