{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # optional-dependencies
  jupyter,
  mediapy,
  numpy,
  packaging,
  protobuf,
  fsspec,
  typing-extensions,
  zipp,
  absl-py,
  simple-parsing,
  einops,
  gcsfs,
  s3fs,
  tqdm,
  dm-tree,
  jax,
  tensorflow,

  # tests
  chex,
  ffmpeg,
  jaxlib,
  optree,
  pydantic,
  pytest-xdist,
  pytestCheckHook,
  torch,
  yapf,
}:

buildPythonPackage (finalAttrs: {
  pname = "etils";
  version = "1.14.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "etils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gjWA+y1dXihmOBzCxfgUZJLvtSHzpRLQIhNxzk+y11M=";
  };

  build-system = [ flit-core ];

  optional-dependencies = lib.fix (self: {
    array-types = self.enp;
    eapp = [
      absl-py
      simple-parsing
    ]
    ++ self.epy;
    ecolab = [
      jupyter
      numpy
      mediapy
      packaging
      protobuf
    ]
    ++ self.enp
    ++ self.epy
    ++ self.etree;
    edc = self.epy;
    enp = [
      numpy
      einops
    ]
    ++ self.epy;
    epath = [
      fsspec
      typing-extensions
      zipp
    ]
    ++ self.epy;
    epath-gcs = [ gcsfs ] ++ self.epath;
    epath-s3 = [ s3fs ] ++ self.epath;
    epy = [ typing-extensions ];
    etqdm = [
      absl-py
      tqdm
    ]
    ++ self.epy;
    etree = self.array-types ++ self.epy ++ self.enp ++ self.etqdm;
    etree-dm = [ dm-tree ] ++ self.etree;
    etree-jax = [ jax ] ++ self.etree;
    etree-tf = [ tensorflow ] ++ self.etree;
    lazy-imports = self.ecolab;
    all =
      self.array-types
      ++ self.eapp
      ++ self.ecolab
      ++ self.edc
      ++ self.enp
      ++ self.epath
      ++ self.epath-gcs
      ++ self.epath-s3
      ++ self.epy
      ++ self.etqdm
      ++ self.etree
      ++ self.etree-dm
      ++ self.etree-jax
      ++ self.etree-tf;
  });

  pythonImportsCheck = [ "etils" ];

  nativeCheckInputs = [
    chex
    optree
    ffmpeg
    jaxlib
    torch
    pydantic
    pytest-xdist
    pytestCheckHook
    yapf
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  # enabledTestPaths = [ ];

  disabledTests = [
    # Requires network access
    "test_public_access"

    # AttributeError: module 'jax._src' has no attribute 'prng'
    "test_array_spec_is_fake"
    "test_array_spec_repr"
    "test_array_spec_tensors"
    "test_array_spec_valid"
    "test_obj"
    "test_spec_like"
  ];

  disabledTestPaths = [
    # Circular dependency with tensorflow-datasets
    "etils/epy/lazy_imports_utils_test.py"

    # Requires unpackaged fiddle
    "etils/epy/text_utils_test.py"
  ];

  meta = {
    description = "Collection of eclectic utils";
    homepage = "https://github.com/google/etils";
    changelog = "https://github.com/google/etils/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
})
