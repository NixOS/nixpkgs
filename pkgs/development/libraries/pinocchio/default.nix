{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, collisionSupport ? !stdenv.isDarwin
, hpp-fcl
, urdfdom
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "2.6.20";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Pu/trCpqdue7sQKDbLhyxTfgj/+xRiVcG7Luz6ZQXtM=";
  };

  # error: use of undeclared identifier '__sincos'
  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace src/math/sincos.hpp \
      --replace "__APPLE__" "0"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
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

  cmakeFlags = lib.optionals collisionSupport [
    "-DBUILD_WITH_COLLISION_SUPPORT=ON"
  ] ++ lib.optionals pythonSupport [
    "-DBUILD_WITH_LIBPYTHON=ON"
  ] ++ lib.optionals (pythonSupport && stdenv.isDarwin) [
    # AssertionError: '.' != '/tmp/nix-build-pinocchio-2.6.20.drv/sou[84 chars].dae'
    "-DCMAKE_CTEST_ARGUMENTS='--exclude-regex;test-py-bindings_geometry_model_urdf'"
  ] ++ lib.optionals (!pythonSupport) [
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

  doCheck = true;

  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "pinocchio"
  ];

  meta = with lib; {
    description = "A fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nim65s wegank ];
    platforms = platforms.unix;
  };
})
