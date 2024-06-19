{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, example-robot-data
, collisionSupport ? !stdenv.isDarwin
, jrl-cmakemodules
, hpp-fcl
, urdfdom
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ks5dvKi5iutjM+iovDOYGx3vsr45JWRqGOXV8+Ko4gg=";
  };

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
    description = "A fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s wegank ];
    platforms = lib.platforms.unix;
  };
})
