{
  buildPythonPackage,
  nvtx, # cudaPackages.nvtx, built from source

  # build-system
  cython,
  setuptools,
  wheel,

  # tests
  numpy,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "nvtx";
  version = nvtx.pythonVersion;
  pyproject = true;
  __structuredAttrs = true;

  # Built from python/ in the NVTX source, against the C headers in c/include next to it; nothing from the C/C++ build
  # is used.
  inherit (nvtx) src;
  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [
    cython
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    setuptools # Builds the injection library used by the tests.
  ];

  # Remove the source of the package to test the installed one.
  preCheck = ''
    rm -r src
  '';

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "nvtx" ];

  passthru.tests.injection = finalAttrs.finalPackage.overrideAttrs {
    pytestFlags = [ "--enable-injection" ];
  };

  meta = {
    description = "Python code annotation library";
    homepage = "https://nvidia.github.io/NVTX/python/";
    changelog = "https://github.com/NVIDIA/NVTX/releases/tag/${finalAttrs.src.tag}";
    inherit (nvtx.meta)
      license
      maintainers
      teams
      ;
  };
})
