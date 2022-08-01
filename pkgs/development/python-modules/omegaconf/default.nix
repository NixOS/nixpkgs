{ lib, buildPythonPackage, fetchFromGitHub, pytest-mock, pytestCheckHook
, pyyaml, pythonOlder, jre_minimal, antlr4_9-python3-runtime }:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omry";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bUJ80sa2ot2JSkt29eFwSiKL6R1X1+VVeE9dFIy4Mg0=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'setup_requires=["pytest-runner"]' 'setup_requires=[]'
  '';

  checkInputs = [ pytestCheckHook pytest-mock ];
  nativeBuildInputs = [ jre_minimal ];
  propagatedBuildInputs = [ antlr4_9-python3-runtime pyyaml ];

  disabledTestPaths = [ "tests/test_pydev_resolver_plugin.py" ];  # needs pydevd - not in Nixpkgs

  meta = with lib; {
    description = "A framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    license = licenses.free;  # prior bsd license (1988)
    maintainers = with maintainers; [ bcdarwin ];
  };
}
