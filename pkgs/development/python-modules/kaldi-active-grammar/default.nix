{ lib
, buildPythonPackage
, fetchFromGitHub
, scikit-build
, cmake
, ush
, requests
, numpy
, cffi
, openfst
, substituteAll
, callPackage
}:

let
  kaldi = callPackage ./fork.nix { };
in
buildPythonPackage rec {
  pname = "kaldi-active-grammar";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "daanzu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lilk6yjzcy31avy2z36bl9lr60gzwhmyqwqn8akq11qc3mbffsk";
  };

  KALDI_BRANCH = "foo";
  KALDIAG_SETUP_RAW = "1";

  patches = [
    # Makes sure scikit-build doesn't try to build the dependencies for us
    ./0001-stub.patch
    # Uses the dependencies' binaries from $PATH instead of a specific directory
    ./0002-exec-path.patch
    # Makes it dynamically link to the correct Kaldi library
    (substituteAll {
      src = ./0003-ffi-path.patch;
      kaldiFork = "${kaldi}/lib";
    })
  ];

  # scikit-build puts us in the wrong folder. That is bad.
  preBuild = ''
    cd ..
  '';

  buildInputs = [ openfst kaldi ];
  nativeBuildInputs = [ scikit-build cmake ];
  propagatedBuildInputs = [ ush requests numpy cffi ];

  doCheck = false;  # no tests exist

  meta = with lib; {
    description = "Python Kaldi speech recognition";
    homepage = "https://github.com/daanzu/kaldi-active-grammar";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ckie ];
    # Other platforms are supported upstream.
    platforms = platforms.linux;
  };
}
