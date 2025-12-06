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

  standalone ? true,
}:
toPythonModule (
  mim-solvers.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" standalone)
    ];

    # this is used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = [
      boost
      crocoddyl
      eigenpy
      osqp
      proxsuite
      scipy
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional standalone mim-solvers;

    nativeCheckInputs = super.nativeCheckInputs ++ [
      pythonImportsCheckHook
      pytest
    ];

    pythonImportsCheck = [
      "mim_solvers"
    ];
  })
)
