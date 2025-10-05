{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
}:

buildGoModule rec {
  pname = "tgpt";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    tag = "v${version}";
    hash = "sha256-mEzTvurjG/58qgNtJie7Iy6rSkiu2VbDIu1MiyrcEyo=";
  };

  vendorHash = "sha256-Xilu4wzDkwf15LmVH0Pkk91/nDisUu66aPP0JvT4ldo=";

  buildInputs = [ libX11 ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Remove test which need network access
    rm src/providers/koboldai/koboldai_test.go
    rm src/providers/phind/phind_test.go
  '';

  meta = {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tgpt";
  };
}
