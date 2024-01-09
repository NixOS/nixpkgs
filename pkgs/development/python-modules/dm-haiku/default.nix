{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, absl-py
, flax
, numpy
, callPackage
, lib
, jmp
, tabulate
, jaxlib
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "dm-haiku";
    rev = "refs/tags/v${version}";
    hash = "sha256-xve1vNsVOC6/HVtzmzswM/Sk3uUNaTtqNAKheFb/tmI=";
  };

  patches = [
    # https://github.com/deepmind/dm-haiku/pull/672
    (fetchpatch {
      name = "fix-find-namespace-packages.patch";
      url = "https://github.com/deepmind/dm-haiku/commit/728031721f77d9aaa260bba0eddd9200d107ba5d.patch";
      hash = "sha256-qV94TdJnphlnpbq+B0G3KTx5CFGPno+8FvHyu/aZeQE=";
    })
  ];

  outputs = [
    "out"
    "testsout"
  ];

  propagatedBuildInputs = [
    absl-py
    flax
    jaxlib
    jmp
    numpy
    tabulate
  ];

  pythonImportsCheck = [
    "haiku"
  ];

  postInstall = ''
    mkdir $testsout
    cp -R examples $testsout/examples
  '';

  # check in passthru.tests.pytest to escape infinite recursion with bsuite
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Haiku is a simple neural network library for JAX developed by some of the authors of Sonnet.";
    homepage = "https://github.com/deepmind/dm-haiku";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
