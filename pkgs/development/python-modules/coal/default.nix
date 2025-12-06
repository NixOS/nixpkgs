{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  coal,

  boost,
  eigenpy,
  pylatexenc,
  numpy,

  standalone ? true,
}:
toPythonModule (
  coal.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" standalone)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      numpy
      pylatexenc
    ];

    propagatedBuildInputs = [
      boost
      eigenpy
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional standalone coal;

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "coal"
      "hppfcl"
    ];
  })
)
