{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "tuc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "riquito";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+QkkwQfp818bKVo1yUkWKLMqbdzRJ+oHpjxB+UFDRsU=";
  };

  cargoHash = "sha256-NbqmXptLmqLd6QizRB1bIM53Rdj010Hy3JqSuLQ4H24=";

  meta = {
    description = "When cut doesn't cut it";
    mainProgram = "tuc";
    homepage = "https://github.com/riquito/tuc";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
