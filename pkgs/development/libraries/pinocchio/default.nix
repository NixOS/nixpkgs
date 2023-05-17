{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, urdfdom
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "pinocchio";
  version = "2.6.18";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-HkNCZpdGi2hJc2+/8XwLrrJcibpyA7fQN1vNuZ9jyhw=";
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
  ] ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ];

  cmakeFlags = lib.optionals (!pythonSupport) [
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

  meta = with lib; {
    description = "A fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
