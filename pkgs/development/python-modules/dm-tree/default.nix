{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pybind11,

  # buildInputs
  abseil-cpp,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  attrs,
  numpy,
  wrapt,
}:
buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    tag = version;
    hash = "sha256-cHuaqA89r90TCPVHNP7B1cfK+WxqmfTXndJ/dRdmM24=";
  };
  # Prefer array flags via CMAKE_FLAGS_NL; fall back to legacy cmakeFlags.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "cmake_args = [" \
        'import os, shlex; _nl=os.environ.get("CMAKE_FLAGS_NL"); _cmf=([l for l in _nl.splitlines() if l] if _nl else shlex.split(os.environ.get("cmakeFlags",""))); cmake_args = [*_cmf,'
    substituteInPlace tree/CMakeLists.txt \
      --replace-fail \
        "CMAKE_CXX_STANDARD 14" \
        "CMAKE_CXX_STANDARD 17"
  '';
  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ABSEIL" true)
    (lib.cmakeBool "USE_SYSTEM_PYBIND11" true)
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  build-system = [ setuptools ];

  # It is unclear whether those are runtime dependencies or simply test dependencies
  # https://github.com/google-deepmind/tree/issues/127
  dependencies = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = {
    description = "Tree is a library for working with nested data structures";
    homepage = "https://github.com/deepmind/tree";
    changelog = "https://github.com/google-deepmind/tree/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      samuela
      ndl
    ];
  };
}
