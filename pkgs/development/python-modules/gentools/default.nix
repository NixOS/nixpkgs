{ buildPythonPackage, lib, fetchFromGitHub, pytest
, typing ? null, funcsigs ? null, pythonOlder
}:

buildPythonPackage rec {
  pname = "gentools";
  version = "1.2.1";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-RBUIji3FOIRjfp4t7zBAVSeiWaYufz4ID8nTWmhDkf8=";
  };

  propagatedBuildInputs =
    lib.optionals (pythonOlder "3.5") [ typing ] ++
    lib.optionals (pythonOlder "3.4") [ funcsigs ];

  nativeCheckInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with lib; {
    description = "Tools for generators, generator functions, and generator-based coroutines";
    license = licenses.mit;
    homepage = "https://gentools.readthedocs.io/";
    maintainers = with maintainers; [ mredaelli ];
  };

}
