{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  coal,

  boost,
  eigenpy,
  pylatexenc,
  numpy,
}:
toPythonModule (
  coal.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      numpy
      pylatexenc
    ];

    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      boost
      coal
      eigenpy
    ];

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "coal"
      "hppfcl"
    ];
  })
)
