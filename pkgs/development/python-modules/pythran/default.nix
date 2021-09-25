{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, openmp
, pytest-runner
, ply
, networkx
, decorator
, gast
, six
, numpy
, beniget
, pytestCheckHook
, scipy
, isPy3k
, substituteAll
}:

let
  inherit (python) stdenv;

in buildPythonPackage rec {
  pname = "pythran";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = version;
    sha256 = "sha256-lQbVq4K/Q8RzlFhE+l3HPCmUGmauXawcKe31kfbUHsI=";
  };

  patches = [
    # Hardcode path to mp library
    (substituteAll {
      src = ./0001-hardcode-path-to-libgomp.patch;
      gomp = "${if stdenv.cc.isClang then openmp else stdenv.cc.cc.lib}/lib/libgomp${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    pytest-runner
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

  checkInputs = [
    pytestCheckHook
    numpy
    scipy
  ];

  # Test suite is huge.
  # Also, in the future scipy will rely on it resulting in a circular test dependency
  doCheck = false;

  disabled = !isPy3k;

  meta = {
    description = "Ahead of Time compiler for numeric kernels";
    homepage = "https://github.com/serge-sans-paille/pythran";
    license = lib.licenses.bsd3;
  };

}
