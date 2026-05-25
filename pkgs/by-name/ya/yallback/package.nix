{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  bashInteractive,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.2.0";
  pname = "yallback";
  src = fetchFromGitHub {
    owner = "abathur";
    repo = "yallback";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t+fdnDJMFiFqN23dSY3TnsZsIDcravtwdNKJ5MiZosE=";
  };

  buildInputs = [
    coreutils
    bashInteractive
  ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dv yallback $out/bin/yallback
    wrapProgram $out/bin/yallback --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  meta = {
    description = "Callbacks for YARA rule matches";
    mainProgram = "yallback";
    homepage = "https://github.com/abathur/yallback";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abathur ];
    platforms = lib.platforms.all;
  };
})
