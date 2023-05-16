{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
<<<<<<< HEAD
, collisionSupport ? !stdenv.isDarwin
, hpp-fcl
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, urdfdom
, pythonSupport ? false
, python3Packages
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "2.6.20";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Pu/trCpqdue7sQKDbLhyxTfgj/+xRiVcG7Luz6ZQXtM=";
=======
stdenv.mkDerivation rec {
  pname = "pinocchio";
  version = "2.6.18";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-HkNCZpdGi2hJc2+/8XwLrrJcibpyA7fQN1vNuZ9jyhw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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

=======
  ] ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ];

  cmakeFlags = lib.optionals (!pythonSupport) [
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = licenses.bsd2;
<<<<<<< HEAD
    maintainers = with maintainers; [ nim65s wegank ];
    platforms = platforms.unix;
  };
})
=======
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
