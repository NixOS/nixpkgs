{ lib
, cmake
, fetchFromGitHub
, buildPythonPackage
, abseil-cpp
, absl-py
, attrs
, numpy
, pybind11
, wrapt
}:

buildPythonPackage rec {
  pname = "dm-tree";
  # As of 2021-12-29, the latest stable version still builds with Bazel.
  version = "42e87fda83278e2eb32bb55225e1d1511e77c10c";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "${version}";
    sha256 = "0bnvnn6m54jp5sr7lbvakdmhbrh2myv79ffmrgl7yjp13mz03lqi";
  };

  patches = [
    ./cmake.patch
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

  checkInputs = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = with lib; {
    description = "Tree is a library for working with nested data structures.";
    homepage = "https://github.com/deepmind/tree";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ndl ];
  };
}
