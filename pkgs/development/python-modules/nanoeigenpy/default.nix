{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  python,

  # nativeBuildInputs
  cmake,
  doxygen,
  nanobind,

  # propagatedBuildInputs
  suitesparse,
  eigen,
  jrl-cmakemodules,

  # dependencies
  numpy,

  # checkInputs
  pytest,
  scipy,
}:

buildPythonPackage rec {
  pname = "nanoeigenpy";
  version = "0.4.0";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "nanoeigenpy";
    tag = "v${version}";
    hash = "sha256-2Lp3fYw3rQYxjkCQCeHI+N32Y4vTJ8l+PoKqLCmAXIU=";
  };

  # Fix:
  # > PermissionError: [Errno 13] Permission denied:
  # > '/nix/store/…-python3-3.12.9/lib/python3.12/site-packages/nanoeigenpy.pyi'
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "$""{Python_SITELIB}" \
      "${python.sitePackages}"
  '';

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeBool "BUILD_WITH_CHOLMOD_SUPPORT" true)
    # Accelerate support in eigen requires
    # https://gitlab.com/libeigen/eigen/-/merge_requests/856
    # which is not in the current eigen v3.4.0-unstable-2022-05-19
    # (lib.cmakeBool "BUILD_WITH_ACCELERATE_SUPPORT" stdenv.hostPlatform.isDarwin)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    nanobind
  ];

  propagatedBuildInputs = [
    suitesparse
    eigen
    jrl-cmakemodules
  ];

  dependencies = [
    numpy
  ];

  checkInputs = [
    pytest
    scipy
  ];

  # Ensure the unit tests are built
  preInstallCheck = "make test";

  pythonImportsCheck = [ "nanoeigenpy" ];

  passthru.updateScript = nix-update-script { };

  postFixup = ''
    substituteInPlace $dev/lib/cmake/nanoeigenpy/nanoeigenpyConfig.cmake \
      --replace-fail $out $dev
  '';

  meta = {
    description = "Support library for bindings between Eigen in C++ and Python, based on nanobind";
    homepage = "https://github.com/Simple-Robotics/nanoeigenpy";
    changelog = "https://github.com/Simple-Robotics/nanoeigenpy/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
