{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cmake
, numpy
, pybind11
, scikit-build-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "17";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gTO7rxgkjdUgSkF6Ztq5bhti5VUpsrhocOLz7L6xllE=";
  };

  # scikit-build-core includes ninja as a required dependency during build-time
  # dependency validation in its get_requires_for_build_wheel method, but it
  # seems to default to whatever CMake's default generator is, which for our
  # CMake is "Unix Makefiles".
  #
  # Setting this environment variable will tell scikit-build-core that we are
  # not using ninja even when it computes its required build dependencies.
  #
  env.CMAKE_GENERATOR = "Unix Makefiles";

  nativeBuildInputs = [
    cmake
    pybind11
    scikit-build-core
  ] ++ scikit-build-core.optional-dependencies.pyproject;

  propagatedBuildInputs = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "awkward_cpp"
  ];

  meta = with lib; {
    description = "CPU kernels and compiled extensions for Awkward Array";
    homepage = "https://github.com/scikit-hep/awkward";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
