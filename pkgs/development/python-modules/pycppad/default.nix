{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,

  # buildInputs
  boost,
  jrl-cmakemodules,

  # propagatedBuildInputs
  cppad,
  cppadcodegen,
  eigen,
  eigenpy,
  numpy,

  # nativeCheckInputs
  ctestCheckHook,

  nix-update-script,

  codegenSupport ? true,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycppad";
  version = "1.2.4";
  pyproject = false; # Built with cmake

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "simple-robotics";
    repo = "pycppad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f+Wz1w4hW2k2ZRrsBV0eVwxsdDGKlEUud6+YWNZbCHw=";
    fetchSubmodules = true; # remove after next release
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    boost
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    cppad
    eigen
    eigenpy
    numpy
  ]
  ++ lib.optional codegenSupport cppadcodegen;

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_WITH_CPPAD_CODEGEN_BINDINGS" codegenSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doInstallCheck)
  ];

  preInstallCheck = ''
    ctestCheckHook
  '';

  pythonImportsCheck = [ "pycppad" ];

  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/pycppad "$dev"
  '';

  passthru = {
    inherit codegenSupport;
    updateScript = nix-update-script { };
  };

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  meta = {
    description = "Python bindings for CppAD and CppADCodeGen using Boost.Python";
    homepage = "https://github.com/simple-robotics/pycppad";
    changelog = "https://github.com/simple-robotics/pycppad/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
