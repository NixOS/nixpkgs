{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  wxGTK32,
  wxsqlite3,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxsqliteplus";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gyH1Wlmg9xQy7xm7rhKZa7BFTFFN4JQHp3CHmzMkVOg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    wxGTK32
    wxsqlite3
    sqlite
  ];

  cmakeFlags = [
    "-DWXSQLITE3_HAVE_CODEC=1"
  ];

  installPhase =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv wxSQLitePlus.app $out/Applications
      makeWrapper $out/{Applications/wxSQLitePlus.app/Contents/MacOS,bin}/wxSQLitePlus
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      install -Dm755 wxSQLitePlus $out/bin/wxSQLitePlus
    '';

  meta = {
    description = "Simple SQLite database browser built with wxWidgets";
    mainProgram = "wxSQLitePlus";
    homepage = "https://github.com/guanlisheng/wxsqliteplus";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
