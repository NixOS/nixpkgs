{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  example-robot-data,

  python,
  pinocchio,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  example-robot-data.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
<<<<<<< HEAD
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
=======
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

<<<<<<< HEAD
    propagatedBuildInputs = [
      pinocchio
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone example-robot-data;
=======
    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      example-robot-data
      pinocchio
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
