{
  lib,
  fetchFromGitHub,

  python3Packages,
  xacro,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "xacrodoc";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamheins";
    repo = "xacrodoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zuyd+lVcrz06yEgapoTjOZP+mxfOsk52rQE33aKV0qI=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.rospkg
    xacro
  ];

  optional-dependencies = {
    mujoco = [
      python3Packages.mujoco
    ];
  };

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [
    "xacrodoc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Compile xacro files to plain URDF or MJCF from Python or the command line (no ROS required)";
    homepage = "https://github.com/adamheins/xacrodoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "xacrodoc";
  };
})
