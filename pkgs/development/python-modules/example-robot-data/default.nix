{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  example-robot-data,

  python,
  pinocchio,
}:
toPythonModule (
  example-robot-data.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      example-robot-data
      pinocchio
    ];

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    # The package expect to find an `example-robot-data/robots` folder somewhere
    # either in install prefix or in the sources
    # where it can find the meshes for unit tests
    preCheck = ''
      ln -s source ../../example-robot-data
    '';

    pythonImportsCheck = [ "example_robot_data" ];
  })
)
