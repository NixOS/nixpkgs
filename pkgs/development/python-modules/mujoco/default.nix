{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # nativeBuildInputs
  cmake,

  # build-system
  setuptools,

  # buildInputs
  mujoco,
  pybind11,

  # dependencies
  absl-py,
  etils,
  glfw,
  numpy,
  pyopengl,
  typing-extensions,

  perl,
  python,
}:

buildPythonPackage rec {
  pname = "mujoco";
  inherit (mujoco) version;

  pyproject = true;

  # We do not fetch from the repository because the PyPi tarball is
  # impurely build via
  # <https://github.com/google-deepmind/mujoco/blob/main/python/make_sdist.sh>
  # in the project's CI.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lw28RAEzccLeZF+cN6m0Hxi0/DaK3IxfgFeYgSG+YQs=";
  };

  nativeBuildInputs = [ cmake ];

  dontUseCmakeConfigure = true;

  build-system = [ setuptools ];

  buildInputs = [
    mujoco
    pybind11
  ];

  dependencies = [
    absl-py
    etils
    glfw
    numpy
    pyopengl
    typing-extensions
  ];

  pythonImportsCheck = [ "${pname}" ];

  env.MUJOCO_PATH = "${mujoco}";
  env.MUJOCO_PLUGIN_PATH = "${mujoco}/lib";
  env.MUJOCO_CMAKE_ARGS = lib.concatStringsSep " " [
    (lib.cmakeBool "MUJOCO_SIMULATE_USE_SYSTEM_GLFW" true)
    (lib.cmakeBool "MUJOCO_PYTHON_USE_SYSTEM_PYBIND11" true)
  ];

  preConfigure =
    # Use non-system eigen3, lodepng, abseil: Remove mirror info and prefill
    # dependency directory. $build from setuptools.
    (
      let
        # E.g. 3.11.2 -> "311"
        pythonVersionMajorMinor =
          with lib.versions;
          "${major python.pythonVersion}${minor python.pythonVersion}";

        # E.g. "linux-aarch64"
        platform = with stdenv.hostPlatform.parsed; "${kernel.name}-${cpu.name}";
      in
      ''
        ${lib.getExe perl} -0777 -i -pe "s/GIT_REPO\n.*\n.*GIT_TAG\n.*\n//gm" mujoco/CMakeLists.txt
        ${lib.getExe perl} -0777 -i -pe "s/(FetchContent_Declare\(\n.*lodepng\n.*)(GIT_REPO.*\n.*GIT_TAG.*\n)(.*\))/\1\3/gm" mujoco/simulate/CMakeLists.txt

        build="/build/${pname}-${version}/build/temp.${platform}-cpython-${pythonVersionMajorMinor}/"
        mkdir -p $build/_deps
        ln -s ${mujoco.pin.lodepng} $build/_deps/lodepng-src
        ln -s ${mujoco.pin.eigen3} $build/_deps/eigen-src
        ln -s ${mujoco.pin.abseil-cpp} $build/_deps/abseil-cpp-src
      ''
    );

  meta = {
    description = "Python bindings for MuJoCo: a general purpose physics simulator";
    inherit (mujoco.meta) homepage changelog license;
    maintainers = with lib.maintainers; [
      GaetanLepage
      tmplt
    ];
  };
}
