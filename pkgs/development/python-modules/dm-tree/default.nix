{
  stdenv,
  abseil-cpp,
  absl-py,
  attrs,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  lib,
  numpy,
  pybind11,
  wrapt,
}:

buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "refs/tags/${version}";
    hash = "sha256-VvSJTuEYjIz/4TTibSLkbg65YmcYqHImTHOomeorMJc=";
  };

  patches = [ ./cmake.patch ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  nativeCheckInputs = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Tree is a library for working with nested data structures.";
    homepage = "https://github.com/deepmind/tree";
    license = licenses.asl20;
    maintainers = with maintainers; [
      samuela
      ndl
    ];
  };
}
