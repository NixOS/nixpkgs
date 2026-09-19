{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cmake,
  ninja,
  cython,
  pybind11,
  re2,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyre2";
  version = "0.3.10";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "andreasvc";
    repo = "pyre2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QF9DSxxsVkCtwzKtwUetN2Nk8TvDPVV4lPz1BYW/1AY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-quiet '"cmake (>=3.18,<4.0.0)",' '"cmake (>=3.18,<5.0.0)",'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    cython
    pybind11
  ];

  pythonRelaxDeps = [
    "cmake"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    re2
  ];

  # pyre2 setup.py calls cmake themselves, but we want to help it find the re2 library
  # Actually, the setup.py is quite custom. Let's see if it works as-is.
  # If not, we might need to disable the custom build_ext or configure it.

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "re2" ];

  meta = {
    description = "Regular expression library using RE2";
    homepage = "https://github.com/andreasvc/pyre2";
    changelog = "https://github.com/andreasvc/pyre2/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
