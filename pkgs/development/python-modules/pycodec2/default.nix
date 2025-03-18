{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # buildInputs
  codec2,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycodec2";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gregorias";
    repo = "pycodec2";
    tag = "v${version}";
    hash = "sha256-5BEJ8q+Onh3eITSmEk2PoNrVViVISULZsiI2cCl24b0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==2.1.*" "numpy"
  '';

  build-system = [
    cython
    numpy
    setuptools
  ];

  buildInputs = [
    codec2
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "pycodec2" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf pycodec2
  '';

  # The only test fails with a cryptic AssertionError
  doCheck = false;

  meta = {
    description = "Python's interface to codec 2";
    homepage = "https://github.com/gregorias/pycodec2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
