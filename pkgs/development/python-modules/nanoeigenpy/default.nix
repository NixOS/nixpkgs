{
  lib,
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,

  cmake,
  doxygen,
  eigen,
  jrl-cmakemodules,
  nanobind,
  numpy,
  pytest,
  python,
  scipy,
  suitesparse,
}:

buildPythonPackage rec {
  pname = "nanoeigenpy";
  version = "0.1.0";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "nanoeigenpy";
    tag = "v${version}";
    hash = "sha256-MPW3Nsqhs2xEHHv9S6ZKn6CNBOOdUDp0U8esBiG/cik=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "DESTINATION $""{Python_SITELIB}" \
      "DESTINATION ${python.sitePackages}"
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
    numpy
  ];

  postInstall = ''
    mv $out/nanoeigenpy.pyi $out/${python.sitePackages}
    moveToOutput "share" $dev
  '';

  checkInputs = [
    pytest
    scipy
  ];

  preInstallCheck = "make test";

  pythonImportsCheck = [ "nanoeigenpy" ];

  meta = {
    description = "Support library for bindings between Eigen in C++ and Python, based on nanobind";
    homepage = "https://github.com/Simple-Robotics/nanoeigenpy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
}
