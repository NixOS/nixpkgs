{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,

  # tests
  chex,
  jaxlib,
  pytest-subtests,
  pytest-xdist,
  pytestCheckHook,
  yapf,

  # optional
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
}:

buildPythonPackage rec {
  pname = "etils";
  version = "1.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pbYMcflbzS1D1On7PcOHkSDB9gRyu1zhn3qGCx1E9gc=";
  };

  postPatch = ''
    # https://github.com/google/etils/pull/722
    substituteInPlace etils/epath/resource_utils.py \
      --replace-fail importlib_resources importlib.resources
    substituteInPlace pyproject.toml \
      --replace-fail '"importlib_resources",' ""
  '';

  build-system = [ flit-core ];

  optional-dependencies = rec {
    array-types = enp;
    eapp = [
      absl-py
      simple-parsing
    ]
    ++ epy;
    ecolab = [
      jupyter
      numpy
      mediapy
      packaging
      protobuf
    ]
    ++ enp
    ++ epy
    ++ etree;
    edc = epy;
    enp = [
      numpy
      einops
    ]
    ++ epy;
    epath = [
      fsspec
      typing-extensions
      zipp
    ]
    ++ epy;
    epath-gcs = [ gcsfs ] ++ epath;
    epath-s3 = [ s3fs ] ++ epath;
    epy = [ typing-extensions ];
    etqdm = [
      absl-py
      tqdm
    ]
    ++ epy;
    etree = array-types ++ epy ++ enp ++ etqdm;
    etree-dm = [ dm-tree ] ++ etree;
    etree-jax = [ jax ] ++ etree;
    etree-tf = [ tensorflow ] ++ etree;
    lazy-imports = ecolab;
    all =
      array-types
      ++ eapp
      ++ ecolab
      ++ edc
      ++ enp
      ++ epath
      ++ epath-gcs
      ++ epath-s3
      ++ epy
      ++ etqdm
      ++ etree
      ++ etree-dm
      ++ etree-jax
      ++ etree-tf;
  };

  pythonImportsCheck = [ "etils" ];

  nativeCheckInputs = [
    chex
    jaxlib
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    yapf
  ]
  ++ optional-dependencies.all;

  disabledTests = [
    "test_public_access" # requires network access
  ];

  doCheck = false; # error: infinite recursion encountered

  meta = {
    changelog = "https://github.com/google/etils/blob/v${version}/CHANGELOG.md";
    description = "Collection of eclectic utils";
    homepage = "https://github.com/google/etils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
