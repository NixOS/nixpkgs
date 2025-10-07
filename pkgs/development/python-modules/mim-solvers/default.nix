{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  mim-solvers,

  boost,
  crocoddyl,
  osqp,
  proxsuite,
  scipy,
  python,
}:
toPythonModule (
  mim-solvers.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    # this is used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = [
      boost
      crocoddyl
      osqp
      proxsuite
      scipy
      mim-solvers
    ]
    ++ super.propagatedBuildInputs;

    nativeCheckInputs = super.nativeCheckInputs ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "mim-solvers"
    ];
  })
)
