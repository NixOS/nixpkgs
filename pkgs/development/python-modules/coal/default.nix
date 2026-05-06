{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  coal,

  boost,
  eigenpy,
  pylatexenc,
  numpy,

  buildStandalone ? true,
}:
toPythonModule (
  coal.overrideAttrs (super: {
    pname = "py-${super.pname}";

    # Finding `boost_system` fails because the stub compiled library of
    # Boost.System, which has been a header-only library since 1.69, was
    # removed in 1.89.
    # See https://www.boost.org/releases/1.89.0/ for details.
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          "find_package(Boost REQUIRED COMPONENTS system)" \
          "find_package(Boost REQUIRED OPTIONAL_COMPONENTS system)"
    '';

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
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
    ++ lib.optional buildStandalone coal;

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "coal"
      "hppfcl"
    ];
  })
)
