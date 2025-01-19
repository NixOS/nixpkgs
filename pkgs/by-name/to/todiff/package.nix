{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "todiff";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Ekleog";
    repo = "todiff";
    rev = version;
    hash = "sha256-leXAmurYjsM/DLe44kLvLwWAs183K96DsRMtrKZFG/g=";
  };

  cargoHash = "sha256-+YAi41A5lOhhz4O6lQ4u567OZj0Lhyyo2UvxPNgONm8=";

  checkFeatures = [ "integration_tests" ];

  meta = {
    description = "Human-readable diff for todo.txt files";
    homepage = "https://github.com/Ekleog/todiff";
    maintainers = with lib.maintainers; [ ekleog ];
    license = lib.licenses.mit;
  };
}
