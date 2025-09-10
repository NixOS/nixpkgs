{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  imagemagick,
}:

stdenv.mkDerivation rec {
  pname = "tiv";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "stefanhaustein";
    repo = "TerminalImageViewer";
    tag = "v${version}";
    hash = "sha256-xuJpl/tGWlyo8aKKy0yYzGladLs3ayKcRCodDNyZI9w=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  postFixup = ''
    wrapProgram $out/bin/tiv \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/stefanhaustein/TerminalImageViewer";
    description = "Small C++ program to display images in a (modern) terminal using RGB ANSI codes and unicode block graphics characters";
    mainProgram = "tiv";
    license = licenses.asl20;
    maintainers = with maintainers; [ magnetophon ];
    platforms = [ "x86_64-linux" ];
  };
}
