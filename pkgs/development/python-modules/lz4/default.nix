{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgconfig,
  psutil,
  pytest-cov-stub,
  pytestCheckHook,
  python,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage {
  pname = "lz4";
  version = "4.4.4-unstable-2025-10-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-lz4";
    repo = "python-lz4";
    rev = "59b2d8176072bdee50d38cc68ec65c33b928a980";
    hash = "sha256-2D30n5j5r4+gcrjEXPu+WpZ4QsugCPyC1xCZuJIPcI0=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "4.4.4";

  build-system = [
    pkgconfig
    setuptools-scm
    setuptools
  ];

  pythonImportsCheck = [
    "lz4"
    "lz4.block"
    "lz4.frame"
    "lz4.stream"
  ];

  nativeCheckInputs = [
    psutil
    pytest-cov-stub
    pytestCheckHook
  ];

  # for lz4.steam
  env.PYLZ4_EXPERIMENTAL = true;

  # prevent local lz4 directory from getting imported as it lacks native extensions
  preCheck = ''
    rm -r lz4
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  meta = {
    description = "LZ4 Bindings for Python";
    homepage = "https://github.com/python-lz4/python-lz4";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
