{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch2
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, distro
, packaging
, setuptools
, wheel
, tomli
  # Test Inputs
, cmake
, cython
, git
, pytestCheckHook
, pytest-mock
, requests
, virtualenv
}:

buildPythonPackage rec {
  pname = "scikit-build";
  version = "0.17.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "scikit_build";
    inherit version;
    hash = "sha256-tRpRo2s3xCZQmUtQR5EvWbIuMhCyPjIfKHYR+e9uXJ0=";
  };

  patches = [
    # https://github.com/scikit-build/scikit-build/pull/1032
    # https://github.com/scikit-build/scikit-build/issues/1047
    ./python312-compatibility.patch

    (fetchpatch2 {
      # https://github.com/scikit-build/scikit-build/pull/1073
      name = "skbuild-suppress-permissionerror.patch";
      url = "https://github.com/scikit-build/scikit-build/commit/41183413e4f5ef29cf3d21e470a2cfa2305733f8.patch";
      hash = "sha256-M5Sbt4CBuiAeGgN0D/toglVi1V2GlA9hPIOMzcqOwdo=";
    })
  ];

  # This line in the filterwarnings section of the pytest configuration leads to this error:
  #  E   UserWarning: Distutils was imported before Setuptools, but importing Setuptools also replaces the `distutils` module in `sys.modules`. This may lead to undesirable behaviors or errors. To avoid these issues, avoid using distutils directly, ensure that setuptools is installed in the traditional way (e.g. not an editable install), and/or make sure that setuptools is always imported before distutils.
  postPatch = ''
    sed -i "/'error',/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    distro
    packaging
    setuptools
    wheel
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    cmake
    cython
    git
    pytestCheckHook
    pytest-mock
    requests
    virtualenv
  ];

  dontUseCmakeConfigure = true;

  disabledTests = [
    "test_hello_develop" # tries setuptools develop install
    "test_source_distribution" # pip has no way to install missing dependencies
    "test_wheel" # pip has no way to install missing dependencies
    "test_fortran_compiler" # passes if gfortran is available
    "test_install_command" # tries to alter out path
    "test_test_command" # tries to alter out path
    "test_setup" # tries to install using distutils
    "test_pep518" # pip exits with code 1
    "test_dual_pep518" # pip exits with code 1
    "test_isolated_env_trigger_reconfigure" # Regex pattern 'exit skbuild saving cmake spec' does not match 'exit skbuild running make'.
    "test_hello_wheel" # [Errno 2] No such file or directory: '_skbuild/linux-x86_64-3.9/setuptools/bdist.linux-x86_64/wheel/helloModule.py'
    # sdist contents differ, contains additional setup.py
    "test_hello_sdist"
    "test_manifest_in_sdist"
    "test_sdist_with_symlinks"
  ];

  meta = with lib; {
    changelog = "https://github.com/scikit-build/scikit-build/blob/${version}/CHANGES.rst";
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    homepage = "https://github.com/scikit-build/scikit-build";
    license = with licenses; [ mit bsd2 ]; # BSD due to reuses of PyNE code
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
