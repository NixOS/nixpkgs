{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  crocoddyl,

  example-robot-data,
  ffmpeg,
  matplotlib,
  nbconvert,
  nbformat,
  ipykernel,
  python,
  scipy,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  crocoddyl.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
<<<<<<< HEAD
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
=======
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

<<<<<<< HEAD
    propagatedBuildInputs = [
      example-robot-data
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone crocoddyl;
=======
    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      crocoddyl
      example-robot-data
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeCheckInputs = [
      ffmpeg
      pythonImportsCheckHook
    ];

    checkInputs = [
      matplotlib
      nbconvert
      nbformat
      ipykernel
      scipy
    ];

    pythonImportsCheck = [
      "crocoddyl"
    ];
<<<<<<< HEAD

    __darwinAllowLocalNetworking = true;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  })
)
