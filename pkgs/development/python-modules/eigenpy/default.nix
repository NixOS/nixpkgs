{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,

  # nativeBuildInputs
  scipy,

  # buildInputs
  boost,
  jrl-cmakemodules,

  # propagatedBuildInputs
  eigen,
  numpy,

  # nativeCheckInputs
  ctestCheckHook,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "eigenpy";
  version = "3.13.0";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eigenpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-05G0U1RjVwggfnABxZH+9kxDIo7M9rgxHCcTvNgTZCQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
    (lib.cmakeBool "BUILD_TESTING_SCIPY" finalAttrs.finalPackage.doInstallCheck)
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    scipy
  ];

  buildInputs = [
    boost
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    eigen
    numpy
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  preInstallCheck = ''
    ctestCheckHook
  '';

  pythonImportsCheck = [ "eigenpy" ];

  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/eigenpy "$dev"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
