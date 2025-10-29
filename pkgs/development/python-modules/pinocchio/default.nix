{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  pinocchio,

  coal,
  casadi,
  matplotlib,
  python,

  standalone ? true,
}:
toPythonModule (
  pinocchio.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" standalone)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = [
      casadi
      coal
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional standalone pinocchio;

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
