{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  fetchpatch2,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  distro,
  packaging,
  setuptools,
  wheel,
  tomli,
  # Test Inputs
  cmake,
  cython,
  git,
  pytestCheckHook,
  pytest-mock,
  requests,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "scikit-build";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "scikit_build";
    inherit version;
    hash = "sha256-caE69GfRo4UQw0lHhuLttz6tU+qSK95uUZ3FNyqmUJY=";
  };

  patches = [
    (fetchpatch2 {
      name = "setuptools-70.2.0-compat.patch";
      url = "https://github.com/scikit-build/scikit-build/commit/7005897053bc5c71d823c36bbd89bd43121670f1.patch";
      hash = "sha256-YGNCS1AXnqHQMd40CDePVNAzLe5gQ/nJxASAZafsxK8=";
    })
  ];

  # This line in the filterwarnings section of the pytest configuration leads to this error:
  #  E   UserWarning: Distutils was imported before Setuptools, but importing Setuptools also replaces the `distutils` module in `sys.modules`. This may lead to undesirable behaviors or errors. To avoid these issues, avoid using distutils directly, ensure that setuptools is installed in the traditional way (e.g. not an editable install), and/or make sure that setuptools is always imported before distutils.
  postPatch = ''
    sed -i "/'error',/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    distro
    packaging
    setuptools
    wheel
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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
    "test_hello_cython_sdist" # [Errno 2] No such file or directory: 'dist/hello-cython-1.2.3.tar.gz'
    "test_hello_pure_sdist" # [Errno 2] No such file or directory: 'dist/hello-pure-1.2.3.tar.gz'
    # sdist contents differ, contains additional setup.py
    "test_hello_sdist"
    "test_manifest_in_sdist"
    "test_sdist_with_symlinks"
  ];

  meta = with lib; {
    changelog = "https://github.com/scikit-build/scikit-build/blob/${version}/CHANGES.rst";
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    homepage = "https://github.com/scikit-build/scikit-build";
    license = with licenses; [
      mit
      bsd2
    ]; # BSD due to reuses of PyNE code
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
