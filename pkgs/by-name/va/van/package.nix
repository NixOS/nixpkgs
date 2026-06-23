{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "van";
  version = "0.8.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "germanphoneguy";
    repo = "van";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xguz5jS4uln4BMKSgQMHKztSKpyNoMQqL+psDPPJO60=";
  };

  cargoHash = "sha256-KaMr6LEZMBZM2dFydW63ubd3ZqN+/SK+p56LeKXELPA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Simple rust code editor with advanced vim-like features";
    homepage = "https://github.com/germanphoneguy/van";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ germanphoneguy ];
    mainProgram = "van";
    platforms = lib.platforms.linux;
  };
})
