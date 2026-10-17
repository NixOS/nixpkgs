{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  rofi,
  todo-txt-cli,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "todofi.sh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hugokernel";
    repo = "todofi.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cvNZ1ofzOP/YRKcnPaarTlgZ0PbSe8tj18zDR20svr4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm 755 todofi.sh -t $out/bin
  '';

  postFixup = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/todofi.sh --prefix PATH : "${
      lib.makeBinPath [
        coreutils
        gawk
        gnugrep
        gnused
        rofi
        todo-txt-cli
      ]
    }"
  '';

  meta = {
    description = "Todo-txt + Rofi = Todofi.sh";
    mainProgram = "todofi.sh";
    homepage = "https://github.com/hugokernel/todofi.sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ewok ];
    platforms = lib.platforms.linux;
  };
})
