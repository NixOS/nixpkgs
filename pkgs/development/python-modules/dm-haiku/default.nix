{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, callPackage
, lib
, jmp
, tabulate
, jaxlib
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EZx3o6PgTeFjTwI9Ko9H39EqPSE0yLWWpsdqX6ALlo4=";
  };

  patches = [
    # https://github.com/deepmind/dm-haiku/issues/717
    (fetchpatch {
      name = "remove-typing-extensions.patch";
      url = "https://github.com/deepmind/dm-haiku/commit/c22867db1a3314a382bd2ce36511e2b756dc32a8.patch";
      hash = "sha256-SxJc8FrImwMqTJ5OuJ1f4T+HfHgW/sGqXeIqlxEatlE=";
    })
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
    jaxlib
    jmp
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
