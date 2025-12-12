{
  lib,
  stdenv,
  fetchFromSourcehut,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "wlopm";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wlopm";
    rev = "v${finalAttr.version}";
    hash = "sha256-GrcV51mUZUaiiYhko8ysaTieJoZDcunLn1yG5k+TpQQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ wayland-scanner ];

  buildInputs = [ wayland ];

  installFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/share/bash-completion/completions
  '';

  meta = {
    description = "Simple client implementing zwlr-output-power-management-v1";
    homepage = "https://git.sr.ht/~leon_plickat/wlopm";
    mainProgram = "wlopm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arjan-s ];
    platforms = lib.platforms.linux;
  };
})
