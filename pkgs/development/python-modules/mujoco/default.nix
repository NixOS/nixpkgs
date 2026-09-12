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

buildPythonPackage (finalAttrs: {
  pname = "mujoco";
  inherit (mujoco) version;

  pyproject = true;
  __structuredAttrs = true;

  # We do not fetch from the repository because the PyPi tarball is
  # impurely build via
  # <https://github.com/google-deepmind/mujoco/blob/main/python/make_sdist.sh>
  # in the project's CI.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-U5F11dsl0Z7BRRcPomR4SmJsXssif3jRh341oKeVX2k=";
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

  pythonImportsCheck = [ "mujoco" ];

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
      ''
      # In 3.13.0, lodepng moved from simulate/CMakeLists.txt to
      # cmake/third_party_deps/lodepng.cmake and uses fetchpackage (same-line args)
      + ''
        ${lib.getExe perl} -0777 -i -pe "s/GIT_REPO[^\n]*\n[^\n]*GIT_TAG[^\n]*\n//g" mujoco/cmake/third_party_deps/lodepng.cmake

        build="build/temp.${platform}-cpython-${pythonVersionMajorMinor}"
        mkdir -p $build/_deps
      ''
      # lodepng needs a custom CMakeLists.txt copied into its source dir by FindOrFetch, so it must
      # be writable
      + ''
        cp -r ${mujoco.pin.lodepng} $build/_deps/lodepng-src
        chmod -R +w $build/_deps/lodepng-src
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
})
