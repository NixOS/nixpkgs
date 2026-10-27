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

buildPythonPackage (finalAttrs: {
  pname = "pycodec2";
  version = "4.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gregorias";
    repo = "pycodec2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDO18uhAhZGaD04rAPinZhkNTww3ibEhw1uJwTtJYWk=";
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
    maintainers = with lib.maintainers; [ drupol ];
  };
})
