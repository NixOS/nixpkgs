{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  substituteAll,

  # build-system
  setuptools,

  # native dependencies
  openmp,
  xsimd,

  # dependencies
  ply,
  gast,
  numpy,
  beniget,
}:

let
  inherit (python) stdenv;
in
buildPythonPackage rec {
  pname = "pythran";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = "refs/tags/${version}";
    hash = "sha256-wiQmShniYZmB8hk/MC5FWFf1s5vqEHiYBkXTo4OeZ+E=";
  };

  patches = [
    (fetchpatch2 {
      name = "bump-gast-to-0.6.0.patch";
      url = "https://github.com/serge-sans-paille/pythran/commit/840a0e706ec39963aec6bcd1f118bf33177c20b4.patch";
      hash = "sha256-FHGXWuAX/Nmn6uEfQgAXfUxIdApDwSfHHtOStxyme/0=";
    })
    # Hardcode path to mp library
    (substituteAll {
      src = ./0001-hardcode-path-to-libgomp.patch;
      gomp = "${
        if stdenv.cc.isClang then openmp else (lib.getLib stdenv.cc.cc)
      }/lib/libgomp${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  # xsimd: unvendor this header-only C++ lib
  postPatch = ''
    rm -r pythran/xsimd
    ln -s '${lib.getDev xsimd}'/include/xsimd pythran/
  '';

  build-system = [ setuptools ];

  dependencies = [
    ply
    gast
    numpy
    beniget
    setuptools
  ];

  pythonImportsCheck = [
    "pythran"
    "pythran.backend"
    "pythran.middlend"
    "pythran.passmanager"
    "pythran.toolchain"
    "pythran.spec"
  ];

  # Test suite is huge and has a circular dependency on scipy.
  doCheck = false;

  meta = {
    changelog = "https://github.com/serge-sans-paille/pythran/blob/${src.rev}/Changelog";
    description = "Ahead of Time compiler for numeric kernels";
    homepage = "https://github.com/serge-sans-paille/pythran";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
