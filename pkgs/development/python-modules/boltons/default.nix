{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "boltons";
  version = "20.2.1";

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "mahmoud";
    repo = "boltons";
    rev = version;
    sha256 = "0vw0h0z81gfxgjfijqiza92ic0siv9xy65mklgj5d0dzr1k9waw8";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mahmoud/boltons/commit/754afddf141ea26956c88c7e13fe5e7ca7942654.patch";
      sha256 = "14kcq8pl4pmgcnlnmj1sh1yrksgym0kn0kgz2648g192svqkbpz8";
    })
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # This test is broken without this PR, which has not yet been merged
    # https://github.com/mahmoud/boltons/pull/283
    "test_frozendict_ior"
  ];

  meta = with lib; {
    homepage = "https://github.com/mahmoud/boltons";
    description = "220+ constructs, recipes, and snippets extending (and relying on nothing but) the Python standard library";
    longDescription = ''
      Boltons is a set of over 220 BSD-licensed, pure-Python utilities
      in the same spirit as — and yet conspicuously missing from — the
      standard library, including:

      - Atomic file saving, bolted on with fileutils
      - A highly-optimized OrderedMultiDict, in dictutils
      - Two types of PriorityQueue, in queueutils
      - Chunked and windowed iteration, in iterutils
      - Recursive data structure iteration and merging, with iterutils.remap
      - Exponential backoff functionality, including jitter, through
      iterutils.backoff
      - A full-featured TracebackInfo type, for representing stack
      traces, in tbutils
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
