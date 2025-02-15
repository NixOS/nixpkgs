{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  hpp-constraints,
  hpp-corbaserver,
  hpp-core,
  hpp-pinocchio,
  hpp-util,
  pkg-config,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-python";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-twBkQqc74kwKkDXWaJg25EtoiqRbTwLlNDvFeP4xs18=";
  };

  strictDeps = true;
  outputs = [
    "out"
    "doc"
  ];

  prePatch = ''
    substituteInPlace doc/configure.py --replace-fail \
      "/usr/bin/env python" "${python3Packages.python.interpreter}"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ];

  propagatedBuildInputs = [
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.lxml
    python3Packages.pinocchio
    hpp-constraints
    hpp-corbaserver
    hpp-core
    hpp-pinocchio
    hpp-util
  ];

  checkInputs = [
    python3Packages.example-robot-data
    python3Packages.pytest
  ];

  env.ROS_PACKAGE_PATH = "${python3Packages.example-robot-data}/share";

  doCheck = true;

  meta = {
    description = "python bindings for HPP, based on boost python";
    homepage = "https://github.com/humanoid-path-planner/hpp-python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
