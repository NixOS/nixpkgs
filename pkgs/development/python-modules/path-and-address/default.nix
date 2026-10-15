{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
}:

buildPythonPackage rec {
  version = "2.0.1";
  format = "setuptools";
  pname = "path-and-address";

  src = fetchFromGitHub {
    owner = "joeyespo";
    repo = "path-and-address";
    rev = "v${version}";
    hash = "sha256-BpYpMQuyTXGgyR/KENh7KjOuqkP1LkjHrgbUqPR1Ciw=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Functions for server CLI applications used by humans";
    homepage = "https://github.com/joeyespo/path-and-address";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koral ];
  };
}
