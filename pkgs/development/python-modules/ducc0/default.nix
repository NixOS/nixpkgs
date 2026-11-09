{
  lib,
  stdenv,
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
  llvmPackages,

  # tests
  pytest-xdist,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "ducc0";
  version = "0.42.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    tag = "ducc0_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-y7YeaSF4fb++26lPNGTdZ6XMgGQnwy0pu1wSAmc/y3s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"pybind11>=2.13.6",' ""
  '';

  env = {
    DUCC0_USE_NANOBIND = "";
    # multiarch compilation is only supported on x86_64
    DUCC0_OPTIMIZATION =
      if stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux then
        "multiarch-strip"
      else
        "portable";
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

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.llvm
  ];

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
