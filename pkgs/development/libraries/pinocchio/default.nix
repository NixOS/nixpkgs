{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, example-robot-data
, collisionSupport ? !stdenv.isDarwin
, console-bridge
, jrl-cmakemodules
, hpp-fcl
, urdfdom
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-h4NzfS27+jWyHbegxF+pgN6JzJdVAoM16J6G/9uNJc4=";
  };

  prePatch = ''
    # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2304
    substituteInPlace unittest/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(contact-cholesky)" ""
  '' + lib.optionalString (stdenv.isLinux && stdenv.isAarch64) ''
    # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2304
    substituteInPlace unittest/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(contact-models)" ""
    # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2277
    substituteInPlace unittest/algorithm/utils/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(force)" ""
  '';

  # example-robot-data models are used in checks.
  # Upstream provide them as git submodule, but we can use our own version instead.
  postPatch = ''
    rmdir models/example-robot-data
    ln -s ${example-robot-data.src} models/example-robot-data
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    console-bridge
    jrl-cmakemodules
    urdfdom
  ] ++ lib.optionals (!pythonSupport) [
    boost
    eigen
  ] ++ lib.optionals (!pythonSupport && collisionSupport) [
    hpp-fcl
  ] ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ] ++ lib.optionals (pythonSupport && collisionSupport) [
    python3Packages.hpp-fcl
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_LIBPYTHON" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
  ] ++ lib.optionals (pythonSupport && stdenv.isDarwin) [
    # AssertionError: '.' != '/tmp/nix-build-pinocchio-2.7.0.drv/sou[84 chars].dae'
    "-DCMAKE_CTEST_ARGUMENTS='--exclude-regex;test-py-bindings_geometry_model_urdf'"
  ];

  doCheck = true;

  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "pinocchio"
  ];

  meta = {
    description = "Fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s wegank ];
    platforms = lib.platforms.unix;
  };
})
