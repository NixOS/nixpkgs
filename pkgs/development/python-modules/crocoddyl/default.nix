{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  crocoddyl,

  example-robot-data,
  ffmpeg,
  matplotlib,
  nbconvert,
  nbformat,
  ipykernel,
  python,
  scipy,

  buildStandalone ? true,
}:
toPythonModule (
  crocoddyl.overrideAttrs (super: {
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
      example-robot-data
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone crocoddyl;

    nativeCheckInputs = [
      ffmpeg
      pythonImportsCheckHook
    ];

    checkInputs = [
      matplotlib
      nbconvert
      nbformat
      ipykernel
      scipy
    ];

    pythonImportsCheck = [
      "crocoddyl"
    ];

    __darwinAllowLocalNetworking = true;
  })
)
