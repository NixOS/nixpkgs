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
  # Allows to forward cmake args through the conventional `cmakeFlags`
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "cmake_args = [" \
        'cmake_args = [ *os.environ.get("cmakeFlags", "").split(),'
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
