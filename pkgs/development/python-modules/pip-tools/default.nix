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

buildPythonPackage rec {
  pname = "pip-tools";
  version = "6.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oeiu5GVEbgInjYDb69QyXR3YYzJI9DITxzol9Y59ilU=";
  };

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

  preCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
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
