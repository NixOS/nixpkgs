{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  mim-solvers,

  # nativeBuildInputs
  python,

  # propagatedBuildInputs
  boost,
  crocoddyl,
  eigenpy,
  osqp,
  proxsuite,
  scipy,

  # nativeCheckInputs
  pytest,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  mim-solvers.overrideAttrs (super: {
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

    propagatedBuildInputs = [
      boost
      crocoddyl
      eigenpy
<<<<<<< HEAD
=======
      mim-solvers
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      osqp
      proxsuite
      scipy
    ]
<<<<<<< HEAD
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone mim-solvers;
=======
    ++ super.propagatedBuildInputs;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeCheckInputs = super.nativeCheckInputs ++ [
      pythonImportsCheckHook
      pytest
    ];

    pythonImportsCheck = [
      "mim_solvers"
    ];
  })
)
