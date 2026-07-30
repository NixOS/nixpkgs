{
  lib,
  buildPythonPackage,
  fetchFromGitLab,

  # build-system
  cmake,
  nanobind,
  ninja,
  scikit-build-core,
  setuptools,

  # dependencies
  numpy,

  # tests
  pytest-xdist,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "ducc0";
  version = "0.41.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    tag = "ducc0_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-OeTTrIcvY9bhnctc6h1xUdSriQN4RNy3vjxWKKlT0ew=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"pybind11>=2.13.6", ' ""
  '';

  env = {
    DUCC0_USE_NANOBIND = "";
    DUCC0_OPTIMIZATION = "portable";
  };

  build-system = [
    cmake
    nanobind
    ninja
    scikit-build-core
    setuptools
  ];
  dontUseCmakeConfigure = true;
  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    scipy
  ];
  enabledTestPaths = [ "python/test" ];
  pythonImportsCheck = [ "ducc0" ];

  postInstall = ''
    mkdir -p $out/include
    cp -r ${finalAttrs.src}/src/ducc0 $out/include
  '';

  meta = {
    description = "Efficient algorithms for Fast Fourier transforms and more";
    homepage = "https://gitlab.mpcdf.mpg.de/mtr/ducc";
    changelog = "https://gitlab.mpcdf.mpg.de/mtr/ducc/-/blob/${finalAttrs.src.tag}/ChangeLog?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ parras ];
  };
})
