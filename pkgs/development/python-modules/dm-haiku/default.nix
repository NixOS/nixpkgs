{ buildPythonPackage
, fetchFromGitHub
, callPackage
, lib
, jmp
, tabulate
, jaxlib
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Qa3g3vOPZJt/wBjjuZHAcFUz/gwN/yvirV/8V9CnIko=";
  };

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
