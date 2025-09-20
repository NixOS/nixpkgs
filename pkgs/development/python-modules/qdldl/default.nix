{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  numpy,
  pybind11,
  setuptools,
  scipy,
  pytestCheckHook,
  qdldl,
}:

buildPythonPackage rec {
  pname = "qdldl";
  version = "0.1.7.post5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "qdldl-python";
    tag = "v${version}";
    hash = "sha256-XHdvYWORHDYy/EIqmlmFQZwv+vK3I+rPIrvcEW1JyIw=";
  };

  # use up-to-date qdldl for CMake v4
  postPatch = ''
    substituteInPlace c/CMakeLists.txt \
      --replace-fail \
        "add_subdirectory(qdldl EXCLUDE_FROM_ALL)" \
        "find_package(qdldl REQUIRED CONFIG)" \
      --replace-fail \
        "add_library(qdldlamd STATIC $""{amd_src} $<TARGET_OBJECTS:qdldlobject>)" \
        "add_library(qdldlamd STATIC $""{amd_src})
         target_link_libraries(qdldlamd qdldl::qdldl)"
    substituteInPlace setup.py \
      --replace-fail \
        "os.path.join('c', 'qdldl', 'include')" \
        "'${lib.getDev qdldl}/include'" \
      --replace-fail \
        "language='c++'," \
        "language='c++',
         extra_link_args=['-lqdldl'],"
    substituteInPlace cpp/qdldl.hpp \
      --replace-fail \
        "#include \"qdldl/include/qdldl.h\"" \
        "#include \"qdldl/qdldl.h\""
    substituteInPlace c/amd/include/SuiteSparse_config.h c/amd/include/perm.h \
      --replace-fail \
        "#include \"qdldl_types.h\"" \
        "#include \"qdldl/qdldl_types.h\""
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    cmake
    numpy
    pybind11
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  propagatedBuildInputs = [
    qdldl
  ];

  pythonImportsCheck = [ "qdldl" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Free LDL factorization routine";
    homepage = "https://github.com/oxfordcontrol/qdldl";
    downloadPage = "https://github.com/oxfordcontrol/qdldl-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
