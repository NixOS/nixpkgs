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
    repo = "tuc";
    rev = "v${version}";
    sha256 = "sha256-+QkkwQfp818bKVo1yUkWKLMqbdzRJ+oHpjxB+UFDRsU=";
  };

  cargoHash = "sha256-Ry7S/Pqo3AoUKCyGFfV9RNWOguBwajJ8rOqRg+LFReY=";

  meta = with lib; {
    description = "When cut doesn't cut it";
    mainProgram = "tuc";
    homepage = "https://github.com/riquito/tuc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
