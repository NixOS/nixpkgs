{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  cmdstan,
  setuptools,
  pandas,
  numpy,
  tqdm,
  stanio,
  xarray,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cmdstanpy";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "cmdstanpy";
    tag = "v${version}";
    hash = "sha256-XVviGdJ41mcjCscL3jvcpHi6zMREHsuShGHpnMQX6V8=";
  };

  patches = [
    (replaceVars ./use-nix-cmdstan-path.patch {
      cmdstan = "${cmdstan}/opt/cmdstan";
    })
  ];

  postPatch = ''
    # conftest.py would have used git to clean up, which is unnecessary here
    rm test/conftest.py
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pandas
    numpy
    tqdm
    stanio
  ];

  optional-dependencies = {
    all = [ xarray ];
  };

  pythonRelaxDeps = [ "stanio" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  disabledTestPaths = [
    # No need to test these when using Nix
    "test/test_install_cmdstan.py"
    "test/test_cxx_installation.py"
  ];

  disabledTests = [
    "test_serialization" # Pickle class mismatch errors
    # These tests use the flag -DSTAN_THREADS which doesn't work in cmdstan (missing file)
    "test_multi_proc_threads"
    "test_compile_force"
    # These tests require a writeable cmdstan source directory
    "test_pathfinder_threads"
    "test_save_profile"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_init_types" # CmdStan error: error during processing Operation not permitted
  ];

  pythonImportsCheck = [ "cmdstanpy" ];

  meta = {
    homepage = "https://github.com/stan-dev/cmdstanpy";
    description = "Lightweight interface to Stan for Python users";
    changelog = "https://github.com/stan-dev/cmdstanpy/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
