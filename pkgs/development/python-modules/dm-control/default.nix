{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  absl-py,
  mujoco,
  pyparsing,
  setuptools,

  # dependencies
  dm-env,
  dm-tree,
  fsspec,
  glfw,
  h5py,
  lxml,
  mock,
  numpy,
  pillow,
  protobuf,
  pyopengl,
  requests,
  scipy,
  tqdm,
  etils,
}:

buildPythonPackage rec {
  pname = "dm-control";
  version = "1.0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "dm_control";
    tag = version;
    hash = "sha256-AESUqrUw8EEUKNtZJ5M/dD7xDr+6VGi4yYacJw0q8Ls=";
  };

  build-system = [
    absl-py
    mujoco
    pyparsing
    setuptools
  ];

  pythonRemoveDeps = [
    # Unpackaged
    "labmaze"
  ];

  dependencies = [
    absl-py
    dm-env
    dm-tree
    fsspec
    glfw
    h5py
    lxml
    mock
    mujoco
    numpy
    pillow
    protobuf
    pyopengl
    pyparsing
    requests
    scipy
    setuptools
    tqdm
  ]
  ++ etils.optional-dependencies.epath;

  pythonImportsCheck = [ "dm_control" ];

  # The installed library clashes with the `dm_control` directory remaining in the source path.
  # Usually, we get around this by `rm -rf` the python source files to ensure that the installed package is used.
  # Here, we cannot do that as it would also remove the tests which are also in the `dm_control` directory.
  # See https://github.com/google-deepmind/dm_control/issues/6
  doCheck = false;

  meta = {
    changelog = "https://github.com/google-deepmind/dm_control/releases/tag/${src.tag}";
    description = "Google DeepMind's software stack for physics-based simulation and Reinforcement Learning environments, using MuJoCo";
    homepage = "https://github.com/google-deepmind/dm_control";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
