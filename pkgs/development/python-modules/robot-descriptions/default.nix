{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  gitpython,
  tqdm,
  # idyntree,
  mujoco,
  pinocchio,
  pybullet,
  pycollada,
  # robomeshcat,
  yourdfpy,
}:

buildPythonPackage rec {
  pname = "robot-descriptions";
<<<<<<< HEAD
  version = "1.22.0";
=======
  version = "1.21.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robot-descriptions";
    repo = "robot_descriptions.py";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4O2mAkO/2xc9cAq55DMdyCzdEwMzAo5uStJwS3rQdws=";
=======
    hash = "sha256-/NH9OaqWVzQ3XSLEJTLlpfeCmF1Iw2ItfyOIO3LuPT4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    gitpython
    tqdm
    pycollada
  ];

  optional-dependencies = {
    opts = [
      # idyntree
      mujoco
      pinocchio
      pybullet
      # robomeshcat
      yourdfpy
    ];
  };

  pythonImportsCheck = [
    "robot_descriptions"
  ];

  # This package needs to download a lot of data at runtime
  doCheck = false;

  meta = {
    description = "Access 125+ robot descriptions from the main Python robotics frameworks";
    homepage = "https://github.com/robot-descriptions/robot_descriptions.py";
    changelog = "https://github.com/robot-descriptions/robot_descriptions.py/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
