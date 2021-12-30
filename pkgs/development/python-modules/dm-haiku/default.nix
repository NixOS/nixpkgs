{ lib
, fetchFromGitHub
, buildPythonPackage
, jmp
, tabulate
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "dm-haiku";
    rev = "v${version}";
    sha256 = "1mdqjcka0m1div63ngba8w8z94id4c1h8xqmnq1xpmgkc79224wa";
  };

  propagatedBuildInputs = [
    jmp
    tabulate
  ];

  pythonImportsCheck = [
    "haiku"
  ];

  # Broken tests: `AttributeError: module 'haiku' has no attribute '_src'` + claims to require lots of specific dependencies like TF-nightly.
  doCheck = false;

  meta = with lib; {
    description = "Haiku is a simple neural network library for JAX developed by some of the authors of Sonnet.";
    homepage = "https://github.com/deepmind/dm-haiku";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
