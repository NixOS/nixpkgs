{ lib, buildPythonPackage, fetchFromGitHub, pytest-mock, pytestCheckHook
, pyyaml, pythonOlder, jre_minimal, antlr4-python3-runtime }:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.1.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omry";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hh6pk4q6nb94bz9rwa6cysf3nj50rmqkjh34pqkh28nzg44afjw";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'setup_requires=["pytest-runner"]' 'setup_requires=[]'
  '';

  checkInputs = [ pytestCheckHook pytest-mock ];
  nativeBuildInputs = [ jre_minimal ];
  propagatedBuildInputs = [ antlr4-python3-runtime pyyaml ];

  disabledTestPaths = [ "tests/test_pydev_resolver_plugin.py" ];  # needs pydevd - not in Nixpkgs

  meta = with lib; {
    description = "A framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    license = licenses.free;  # prior bsd license (1988)
    maintainers = with maintainers; [ bcdarwin ];
  };
}
