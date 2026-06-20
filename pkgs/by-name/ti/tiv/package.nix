{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tiv";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "stefanhaustein";
    repo = "TerminalImageViewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xuJpl/tGWlyo8aKKy0yYzGladLs3ayKcRCodDNyZI9w=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [ makeBinaryWrapper ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postFixup = ''
    wrapProgram $out/bin/tiv \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]}
  '';

  meta = {
    homepage = "https://github.com/stefanhaustein/TerminalImageViewer";
    description = "Small C++ program to display images in a (modern) terminal using RGB ANSI codes and unicode block graphics characters";
    mainProgram = "tiv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = [ "x86_64-linux" ];
  };
})
