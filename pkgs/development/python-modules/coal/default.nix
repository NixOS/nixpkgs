{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  coal,

  boost,
  eigenpy,
  pylatexenc,
  numpy,
<<<<<<< HEAD

  buildStandalone ? true,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
toPythonModule (
  coal.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
<<<<<<< HEAD
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
=======
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];

    # those are used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      numpy
      pylatexenc
    ];

<<<<<<< HEAD
    propagatedBuildInputs = [
      boost
      eigenpy
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone coal;
=======
    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      boost
      coal
      eigenpy
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeCheckInputs = [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "coal"
      "hppfcl"
    ];
  })
)
