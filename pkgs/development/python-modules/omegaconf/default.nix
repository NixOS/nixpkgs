{ lib, buildPythonPackage, fetchFromGitHub, pytest-runner, pytest-mock
, pytestCheckHook, pyyaml, isPy27, jre_minimal, antlr4-python3-runtime }:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.1.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "omry";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0aDlqPXELxQ/lnw4Hd9es8ldYhUP/TacH9AIyaffwnI=";
  };

  checkInputs = [ pytestCheckHook pytest-mock ];
  nativeBuildInputs = [ jre_minimal pytest-runner ];
  propagatedBuildInputs = [ antlr4-python3-runtime pyyaml ];

  disabledTestPaths = [ "tests/test_pydev_resolver_plugin.py" ];  # needs pydevd - not in Nixpkgs

  meta = with lib; {
    description = "A framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    license = licenses.free;  # prior bsd license (1988)
    maintainers = with maintainers; [ bcdarwin ];
  };
}
