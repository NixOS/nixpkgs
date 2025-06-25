{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgconfig,
  psutil,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "lz4";
  version = "4.4.4";
  pyproject = true;

  disabled = pythonOlder "3.5";

  # get full repository in order to run tests
  src = fetchFromGitHub {
    owner = "python-lz4";
    repo = "python-lz4";
    tag = "v${version}";
    hash = "sha256-RoM2U47T5WLepJlbJhJAeqKRP8Zf3twndqmMSViI5Z8=";
  };

  postPatch = ''
    sed -i '/pytest-cov/d' setup.py
  '';

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
    pytestCheckHook
  ];

  # for lz4.steam
  env.PYLZ4_EXPERIMENTAL = true;

  # prevent local lz4 directory from getting imported as it lacks native extensions
  preCheck = ''
    rm -r lz4
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  meta = with lib; {
    description = "LZ4 Bindings for Python";
    homepage = "https://github.com/python-lz4/python-lz4";
    changelog = "https://github.com/python-lz4/python-lz4/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
