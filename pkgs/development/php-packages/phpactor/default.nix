{ mkDerivation, fetchFromGitHub, lib, composer, git }:
let
  pname = "phpactor";
  version = "0.17.2";
in
mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = "0.17.2";
    sha256 = "sha256-rEpuWToVU7qDLd68qSpMy9SDAOyOUEzFP04E6CU4DM4=";
  };

  nativeBuildInputs = [ composer git ];

  installPhase = ''
    export HOME=$(mktemp -d)
    composer install
  '';

  meta = with lib; {
    description = "This project aims to provide heavy-lifting refactoring and introspection tools which can be used standalone or as the backend for a text editor to provide intelligent code completion.";
    license = licenses.mit;
    homepage = "https://github.com/phpactor/phpactor";
  };
}
