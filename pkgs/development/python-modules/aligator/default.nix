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
}:
toPythonModule (
  aligator.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    # this is used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      aligator
      crocoddyl
      pinocchio
    ];

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
