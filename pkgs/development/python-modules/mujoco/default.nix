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
    hash = "sha256-kl7+5cMvaAaILEARKs5KPtdLE7Kv8J7NddZnj6oLwk8=";
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
  ];

  pythonImportsCheck = [ "${pname}" ];

  env.MUJOCO_PATH = "${mujoco}";
  env.MUJOCO_PLUGIN_PATH = "${mujoco}/lib";
  env.MUJOCO_CMAKE_ARGS = lib.concatStringsSep " " [
    "-DMUJOCO_SIMULATE_USE_SYSTEM_GLFW=ON"
    "-DMUJOCO_PYTHON_USE_SYSTEM_PYBIND11=ON"
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
        ${perl}/bin/perl -0777 -i -pe "s/GIT_REPO\n.*\n.*GIT_TAG\n.*\n//gm" mujoco/CMakeLists.txt
        ${perl}/bin/perl -0777 -i -pe "s/(FetchContent_Declare\(\n.*lodepng\n.*)(GIT_REPO.*\n.*GIT_TAG.*\n)(.*\))/\1\3/gm" mujoco/simulate/CMakeLists.txt

        build="/build/${pname}-${version}/build/temp.${platform}-cpython-${pythonVersionMajorMinor}/"
        mkdir -p $build/_deps
        ln -s ${mujoco.pin.lodepng} $build/_deps/lodepng-src
        ln -s ${mujoco.pin.eigen3} $build/_deps/eigen-src
        ln -s ${mujoco.pin.abseil-cpp} $build/_deps/abseil-cpp-src
      ''
    );

  meta = {
    description = "Python bindings for MuJoCo: a general purpose physics simulator";
    homepage = "https://mujoco.org/";
    changelog = "https://github.com/google-deepmind/mujoco/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      tmplt
    ];
  };
}
