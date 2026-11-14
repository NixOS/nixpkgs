{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  pinocchio,

  coal,
  casadi,
  matplotlib,
  pybind11,
  pycppad,
  python,

  autodiffSupport ? true,
  buildStandalone ? true,
  codegenSupport ? true,
}:

assert codegenSupport -> autodiffSupport;
assert codegenSupport -> pycppad.codegenSupport;

toPythonModule (
  (pinocchio.override { inherit autodiffSupport codegenSupport; }).overrideAttrs (super: {
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
    ++ lib.optional autodiffSupport pycppad
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

    passthru = {
      inherit buildStandalone;
    };
  })
)
