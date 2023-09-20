{ buildPythonPackage, lib, fetchFromGitHub, pytest
, typing ? null, funcsigs ? null, pythonOlder
}:

buildPythonPackage rec {
  pname = "gentools";
  version = "1.1.0";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sm6cqi7fv2k3pc68r7wvvjjz8y6cjmz8bvxgqfa4v4wxibwnwrl";
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
