################################################################################
# WARNING: Changes made to this file MUST go through the usual PR review process
#          and MUST be approved by a member of `meta.maintainers` before
#          merging. Commits attempting to circumvent the PR review process -- as
#          part of python-updates or otheriwse -- will be reverted without
#          notice.
################################################################################
{ stdenv
, abseil-cpp
, absl-py
, attrs
, buildPythonPackage
, cmake
, fetchFromGitHub
, lib
, numpy
, pybind11
, wrapt
}:

buildPythonPackage rec {
  pname = "dm-tree";
  # As of 2021-12-29, the latest stable version still builds with Bazel.
  version = "unstable-2021-12-20";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "b452e5c2743e7489b4ba7f16ecd51c516d7cd8e3";
    sha256 = "1r187xwpvnnj98lyasngcv3lbxz0ziihpl5dbnjbfbjr0kh6z0j9";
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
    broken = stdenv.isDarwin;
    description = "Tree is a library for working with nested data structures.";
    homepage = "https://github.com/deepmind/tree";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ndl ];
  };
}
