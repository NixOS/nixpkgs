{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, casadi
, cmake
, boost
, eigen
, example-robot-data
, casadiSupport ? true
, collisionSupport ? true
, console-bridge
, jrl-cmakemodules
, hpp-fcl
, urdfdom
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WgMqb+NHnaxW9/qSZ0UGI4zGxGjh12a5DwtdX9byBiw=";
  };

  # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2277
  prePatch = lib.optionalString (stdenv.isLinux && stdenv.isAarch64) ''
    substituteInPlace unittest/algorithm/utils/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(force)" ""
  '';

  patches = [
    # fix urdf & collision support on aarch64-darwin
    (fetchpatch {
      name = "static-pointer_cast.patch";
      url = "https://github.com/stack-of-tasks/pinocchio/pull/2339/commits/ead869e8f3cce757851b9a011c4a2f55fb66582b.patch";
      hash = "sha256-CkrWQJP/pPNs6B3a1FclfM7JWwkmsPzRumS46KQHv0s=";
    })
  ];

  postPatch = ''
    # example-robot-data models are used in checks.
    # Upstream provide them as git submodule, but we can use our own version instead.
    rmdir models/example-robot-data
    ln -s ${example-robot-data.src} models/example-robot-data

    # allow package:// uri use in examples
    export ROS_PACKAGE_PATH=${example-robot-data}/share
  '';

  # CMAKE_BUILD_TYPE defaults to Release in this package,
  # which enable -O3, which break some tests
  # ref. https://github.com/stack-of-tasks/pinocchio/issues/2304#issuecomment-2231018300
  postConfigure = ''
    substituteInPlace CMakeCache.txt --replace-fail '-O3' '-O2'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals pythonSupport [
    python3Packages.python
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
  ] ++ lib.optionals (!pythonSupport && casadiSupport) [
    casadi
  ] ++ lib.optionals (pythonSupport && casadiSupport) [
    python3Packages.casadi
  ];

  checkInputs = lib.optionals (pythonSupport && casadiSupport) [ python3Packages.matplotlib ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_LIBPYTHON" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_CASADI_SUPPORT" casadiSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
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
