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

  standalone ? true,
}:
toPythonModule (
  aligator.overrideAttrs (super: {
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
      crocoddyl
      pinocchio
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional standalone aligator;

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
  })
)
