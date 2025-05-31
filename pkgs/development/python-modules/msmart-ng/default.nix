{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  httpx,
  pycryptodome,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "msmart-ng";
  version = "2025.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-msmart";
    tag = version;
    hash = "sha256-dZD93ZZiQLmWuMAR/nnYB7oGBBYr4YPEi+LdpSzweVc=";
  };

  patches = [
    (fetchpatch2 {
      # Revert <https://github.com/mill1000/midea-msmart/pull/209> until setuptools
      # implements support for <https://peps.python.org/pep-0639/>.
      name = "revert-pyproject-license-declaration-pep639-syntax.patch";
      url = "https://github.com/mill1000/midea-msmart/commit/e5d6a982135e497c251095e421d3de4686f36056.patch?full_index=1";
      hash = "sha256-+mxmFGZd04MZY2C5eo4k1lFoXsM8XyeJNazShnjAseE=";
      revert = true;
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    httpx
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # network access
    "msmart/tests/test_cloud.py"
  ];

  pythonImportsCheck = [ "msmart" ];

  meta = with lib; {
    changelog = "https://github.com/mill1000/midea-msmart/releases/tag/${src.tag}";
    description = "Python library for local control of Midea (and associated brands) smart air conditioners";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = licenses.mit;
    mainProgram = "msmart-ng";
    maintainers = with maintainers; [
      hexa
      emilylange
    ];
  };
}
