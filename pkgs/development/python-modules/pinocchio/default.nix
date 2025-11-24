{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  pinocchio,

  coal,
  casadi,
  matplotlib,
  python,
}:
toPythonModule (
  pinocchio.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      casadi
      coal
      pinocchio
    ];

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
