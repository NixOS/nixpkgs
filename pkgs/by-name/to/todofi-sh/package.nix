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

stdenv.mkDerivation rec {
  pname = "todofi.sh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hugokernel";
    repo = "todofi.sh";
    rev = "v${version}";
    sha256 = "1gmy5inlghycsxiwnyyjyv81jn2fmfk3s9x78kcgyf7khzb5kwvj";
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

  meta = with lib; {
    description = "Todo-txt + Rofi = Todofi.sh";
    mainProgram = "todofi.sh";
    homepage = "https://github.com/hugokernel/todofi.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
  };
}
