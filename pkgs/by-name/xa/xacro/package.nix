{
  lib,
  fetchFromGitHub,

  python3Packages,

  ament-cmake,
  ament-cmake-export-definitions,
  ament-cmake-export-include-directories,
  ament-cmake-export-libraries,
  ament-cmake-export-link-flags,
  ament-cmake-export-targets,
  ament-cmake-gen-version-h,
  ament-cmake-include-directories,
  ament-cmake-libraries,
  ament-cmake-pytest,
  ament-cmake-python,
  ament-cmake-target-dependencies,
  ament-cmake-test,
  ament-cmake-version,
  ament-lint-auto,
  cmake,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "xacro";
  version = "2.1.1";
  pyproject = false; # build with CMake to get tests

  src = fetchFromGitHub {
    owner = "ros";
    repo = "xacro";
    tag = finalAttrs.version;
    hash = "sha256-xYFwVM5qpy2/cYKtcf/v5sSlL2e/taIC4IQ48ZiRxiw=";
  };

  postPatch = ''
    patchShebangs test/test-cmake.sh
  '';

  build-system = [
    cmake
    python3Packages.setuptools
  ];

  buildInputs = [
    ament-cmake
    ament-cmake-export-definitions
    ament-cmake-export-include-directories
    ament-cmake-export-libraries
    ament-cmake-export-link-flags
    ament-cmake-export-targets
    ament-cmake-gen-version-h
    ament-cmake-include-directories
    ament-cmake-libraries
    ament-cmake-python
    ament-cmake-target-dependencies
    ament-cmake-test
    ament-cmake-version
  ];

  nativeCheckInputs = [
    python3Packages.pytest
  ];

  checkInputs = [
    python3Packages.ament-index-python
    ament-lint-auto
    ament-cmake-pytest
  ];

  dependencies = [
    python3Packages.ament-package
    python3Packages.catkin-pkg
    python3Packages.pyyaml
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doInstallCheck)
  ];

  preInstallCheck = ''
    export PATH=$out/bin:$PATH
    export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
  '';

  installCheckTarget = "test";

  pythonImportsCheck = [ "xacro" ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Xacro is an XML macro language. With xacro, you can construct shorter and more readable XML files by using macros that expand to larger XML expressions";
    homepage = "https://github.com/ros/xacro";
    changelog = "https://github.com/ros/xacro/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "xacro";
  };
})
