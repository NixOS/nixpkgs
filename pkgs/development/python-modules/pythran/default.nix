{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, openmp
, ply
, networkx
, decorator
, gast
, six
, numpy
, beniget
, isPy3k
, substituteAll
}:

let
  inherit (python) stdenv;

in buildPythonPackage rec {
  pname = "pythran";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = version;
    hash = "sha256-F9gUZOTSuiqvfGoN4yQqwUg9mnCeBntw5eHO7ZnjpzI=";
  };

  patches = [
    # Hardcode path to mp library
    (substituteAll {
      src = ./0001-hardcode-path-to-libgomp.patch;
      gomp = "${if stdenv.cc.isClang then openmp else stdenv.cc.cc.lib}/lib/libgomp${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  propagatedBuildInputs = [
    ply
    networkx
    decorator
    gast
    six
    numpy
    beniget
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

  disabled = !isPy3k;

  meta = {
    description = "Ahead of Time compiler for numeric kernels";
    homepage = "https://github.com/serge-sans-paille/pythran";
    license = lib.licenses.bsd3;
  };
}
