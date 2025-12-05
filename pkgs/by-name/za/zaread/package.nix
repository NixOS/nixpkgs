{
  stdenv,
  fetchFromGitHub,
  lib,
  zathura,
  libreoffice,
  libreofficeSupport ? true,
  md2pdf,
  markdownSupport ? true,
  calibre,
  mobiSupport ? true,
  typst,
  typstSupport ? true,
  makeWrapper,
  bashNonInteractive,
}:

let
  name = "zaread";
  url = "https://github.com/paoloap/zaread";
in
stdenv.mkDerivation {
  pname = name;
  version = "0-unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "paoloap";
    repo = name;
    rev = "d4935a72d19bf9c5c035c1363ef798574b6738e7";
    hash = "sha256-4tqi9tvFqB5MZIEluqVmmMWH+hN1c2Jy10C1/iGI6e4=";
  };

  pathAdd = lib.makeBinPath (
    [
      zathura
    ]
    ++ lib.optionals libreofficeSupport [ libreoffice ]
    ++ lib.optionals markdownSupport [ md2pdf ]
    ++ lib.optionals mobiSupport [ calibre ]
    ++ lib.optionals typstSupport [ typst ]
  );

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashNonInteractive ];
  dontBuild = true;

  installPhase = ''
    install -Dm 755 $src/zaread $out/bin/zaread
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/zaread --prefix PATH : $pathAdd
  '';

  meta = {
    description = "A lightweight document reader";
    homepage = url;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nicknb ];
    platforms = lib.platforms.unix;
  };
}
