{
  lib,

  toPythonModule,
  pythonImportsCheckHook,
  stdenv,

  aligator,

  crocoddyl,
  pinocchio,
  python,
  matplotlib,
  pytest,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  aligator.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
<<<<<<< HEAD
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
=======
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];

    # this is used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

<<<<<<< HEAD
    propagatedBuildInputs = [
      crocoddyl
      pinocchio
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone aligator;
=======
    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      aligator
      crocoddyl
      pinocchio
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    checkInputs = super.checkInputs ++ [
      matplotlib
      pytest
    ];

    disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
      # SIGTRAP
      "aligator-test-py-rollout"
    ];

    pythonImportsCheck = [
      "aligator"
    ];
<<<<<<< HEAD

    __darwinAllowLocalNetworking = true;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  })
)
