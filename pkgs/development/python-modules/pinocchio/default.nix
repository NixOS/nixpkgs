{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  pinocchio,

  coal,
  casadi,
  matplotlib,
  pybind11,
  python,

  buildStandalone ? true,
}:
toPythonModule (
  pinocchio.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = [
      casadi
      coal
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone pinocchio;

    checkInputs = super.checkInputs ++ [
      matplotlib
      pybind11
    ];

    nativeCheckInputs = super.nativeCheckInputs ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "pinocchio"
    ];
  })
)
