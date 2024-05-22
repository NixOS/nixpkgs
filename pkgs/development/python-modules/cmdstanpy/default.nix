{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,
  cmdstan,
  pythonRelaxDepsHook,
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
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "cmdstanpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-q+AFhWEzjYElJpiHT4h6YfZrwZJ56pv+8R+001vREyQ=";
  };

  patches = [
    (substituteAll {
      src = ./use-nix-cmdstan-path.patch;
      cmdstan = "${cmdstan}/opt/cmdstan";
    })
  ];

  postPatch = ''
    # conftest.py would have used git to clean up, which is unnecessary here
    rm test/conftest.py
  '';

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    pandas
    numpy
    tqdm
    stanio
  ];

  passthru.optional-dependencies = {
    all = [ xarray ];
  };

  pythonRelaxDeps = [ "stanio" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.all;

  disabledTestPaths = [
    # No need to test these when using Nix
    "test/test_install_cmdstan.py"
    "test/test_cxx_installation.py"
  ];

  disabledTests =
    [
      "test_serialization" # Pickle class mismatch errors
      # These tests use the flag -DSTAN_THREADS which doesn't work in cmdstan (missing file)
      "test_multi_proc_threads"
      "test_compile_force"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_init_types" # CmdStan error: error during processing Operation not permitted
    ];

  pythonImportsCheck = [ "cmdstanpy" ];

  meta = {
    homepage = "https://github.com/stan-dev/cmdstanpy";
    description = "A lightweight interface to Stan for Python users";
    changelog = "https://github.com/stan-dev/cmdstanpy/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
