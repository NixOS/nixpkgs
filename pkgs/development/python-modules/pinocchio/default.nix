{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  pinocchio,

  coal,
  casadi,
  matplotlib,
  python,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  pinocchio.overrideAttrs (super: {
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
      casadi
      coal
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone pinocchio;
=======
    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      casadi
      coal
      pinocchio
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    checkInputs = super.checkInputs ++ [
      matplotlib
    ];

    nativeCheckInputs = super.nativeCheckInputs ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "pinocchio"
    ];
  })
)
