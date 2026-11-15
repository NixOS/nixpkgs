{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  numpy,
  torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "mslk";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "MSLK";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/oC8FttZvJxrfNWR9LEzTeqiTtjBbuLNst/TMIsl4qU=";
  };

  patches = [
    # Fix the triton split-K attention kernel indexing
    # https://github.com/meta-pytorch/MSLK/pull/630
    (fetchpatch {
      name = "mslk-fix-splitk-dequantize-indexing.patch";
      url = "https://github.com/meta-pytorch/MSLK/commit/eda292adf77431c3f9a16893561e9903f9b19fca.patch";
      hash = "sha256-EUUAZBfSW6cEltejGn4neTZkft798LkJhaI/ygIionk=";
    })
    # Fix triton >= 3.9 compatibility (block pointers have been removed)
    # https://github.com/meta-pytorch/MSLK/pull/619
    (fetchpatch {
      name = "mslk-splitk-remove-block-pointers.patch";
      url = "https://github.com/meta-pytorch/MSLK/commit/78ccdcee3c3af20820a74f8abccddb0a4d84e3f8.patch";
      hash = "sha256-cz5dCs8YlifhkXlvjKIWMATRf+gtP4ffFv+pto+c1wg=";
    })
  ];

  env = {
    # Skip the C++/CUDA build (CMake + scikit-build) and only install the Python code.
    # The native kernels are optional: the triton/flash-attention based ops work without them.
    MSLK_PYTHON_ONLY = 1;
    MSLK_VERSION_OVERRIDE = finalAttrs.version;
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    torch
  ];

  pythonImportsCheck = [
    "mslk"
    "mslk.attention.fmha"
  ];

  # Almost all tests require a GPU
  doCheck = false;

  meta = {
    description = "Collection of PyTorch GPU operator libraries for GenAI training and inference";
    homepage = "https://github.com/meta-pytorch/MSLK";
    changelog = "https://github.com/meta-pytorch/MSLK/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
