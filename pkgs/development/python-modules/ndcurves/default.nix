{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  ndcurves,

  boost,
  pinocchio,
  python,

  buildStandalone ? true,
}:
toPythonModule (
  ndcurves.overrideAttrs (super: {
    pname = "py-${super.pname}";
    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
    ];
    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];
    propagatedBuildInputs = [
      boost
      pinocchio
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone ndcurves;

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "ndcurves"
    ];
  })
)
