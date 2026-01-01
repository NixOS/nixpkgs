{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  ndcurves,

  boost,
  pinocchio,
  python,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  ndcurves.overrideAttrs (super: {
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
    propagatedBuildInputs = [
      boost
      pinocchio
<<<<<<< HEAD
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone ndcurves;

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

=======
      ndcurves
    ]
    ++ super.propagatedBuildInputs;
    nativeCheckInputs = [
      pythonImportsCheckHook
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pythonImportsCheck = [
      "ndcurves"
    ];
  })
)
