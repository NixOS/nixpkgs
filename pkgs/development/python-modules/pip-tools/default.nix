{ lib
, stdenv
, buildPythonPackage
, build
, click
, fetchPypi
, pep517
, pip
, pytest-xdist
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, setuptools-scm
, wheel
}:

let
  # In some test cases, the `build` package needs to be able to `pip install`
  # the `wheel` package [1]. Since we cannot provide network access, we create a
  # derivation that holds a .whl of the `wheel` package and specify it as a
  # `--find-links` directory. This is done by the `fix-setup-py-bad-syntax-detection`
  # patch that uses the `NIX_PIP_FIND_LINKS` env var exported by the `preCheck`
  # script.
  #
  # [1] How and why that is the case:
  # * `build.util.project_wheel_metadata()`, a function called by pip-compile,
  #   creates an isolated build environment using `venv`. However, virtualenvs
  #   created by `venv` doesn't have `wheel` installed.
  # * After creating a build environment, `project_wheel_metadata()` runs
  #   `pip install -r` to install the packages required by the build backend.
  # * `build` falls back to its default build backend when a project doesn't
  #   define one, which is the case with some of the test cases.
  # * The default build backend's `requires` list includes the `wheel` package`.
  # * Because `wheel` is missing from the build environment, `pip` tries
  #   to install it.
  wheelhouse = wheel.overrideAttrs (old: {
    name = "pip-tools-build-wheelhouse";
    installPhase = ''
      mkdir -p $out
      cp dist/*.whl $out
    '';
  });
in
buildPythonPackage rec {
  pname = "pip-tools";
  version = "6.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oeiu5GVEbgInjYDb69QyXR3YYzJI9DITxzol9Y59ilU=";
  };

  patches = [ ./fix-setup-py-bad-syntax-detection.patch ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    build
    click
    pep517
    pip
    setuptools
    wheel
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = (lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '') + ''
    # Used by ./fix-setup-py-bad-syntax-detection.patch
    export NIX_PIP_FIND_LINKS=${wheelhouse}
  '';

  disabledTests = [
    # Tests require network access
    "network"
    "test_direct_reference_with_extras"
    "test_local_duplicate_subdependency_combined"
  ] ++ (lib.optional (pythonAtLeast "3.8" && pythonOlder "3.10")
    # Ignore test_cli_compile.py's `test_bad_setup_file` test case on Python
    # versions that don't yet include a fix for this issue with `ensurepip`:
    # https://github.com/python/cpython/issues/90355
    #
    # pip-compile uses `build.util.project_wheel_metadata()` to get dependencies
    # from project setup files, and `build.env.IsolatedEnvBuilder`, a class used
    # by `project_wheel_metadata()`, has code that gets the version of `pip` that's
    # installed in its isolated env. The bug in `ensurepip` causes the isolated
    # env to have no `pip` package installed if it's found in an outer environment,
    # This happnes to be the case with Nix build environments, which results in a
    # `StopIteration` exception in `IsolatedEnvBuilder`, causing this test case to fail.
    "test_bad_setup_file"
  );

  pythonImportsCheck = [
    "piptools"
  ];

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
