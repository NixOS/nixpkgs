{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build,
  cmake,
  ush,
  requests,
  six,
  numpy,
  cffi,
  openfst,
  replaceVars,
  callPackage,
}:

#
# Maintainer note: only in-tree dependant is `dragonfly`, try to
# update the two alongside eachother.
#

let
  kaldi = callPackage ./fork.nix { };
in
buildPythonPackage rec {
  pname = "kaldi-active-grammar";
  version = "3.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "daanzu";
    repo = "kaldi-active-grammar";
    tag = "v${version}";
    sha256 = "sha256-VyVshIEVp/ep4Ih7Kj66GF02JEZ4nwgJOtgR2DarzdY=";
  };

  env = {
    KALDI_BRANCH = "foo";
    KALDIAG_SETUP_RAW = "1";
  };

  patches = [
    # Makes sure scikit-build doesn't try to build the dependencies for us
    ./0001-stub.patch
    # Uses the dependencies' binaries from $PATH instead of a specific directory
    ./0002-exec-path.patch
    # Makes it dynamically link to the correct Kaldi library
    (replaceVars ./0003-ffi-path.patch {
      kaldiFork = "${kaldi}/lib";
    })
  ];

  # scikit-build puts us in the wrong folder. That is bad.
  preBuild = ''
    cd ..
  '';

  buildInputs = [
    openfst
    kaldi
  ];
  nativeBuildInputs = [
    scikit-build
    cmake
  ];
  propagatedBuildInputs = [
    ush
    requests
    numpy
    cffi
    six
  ];

  doCheck = false; # no tests exist

  meta = {
    description = "Python Kaldi speech recognition";
    homepage = "https://github.com/daanzu/kaldi-active-grammar";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    # Other platforms are supported upstream.
    platforms = lib.platforms.linux;
  };
}
