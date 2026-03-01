{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxsqlite3";
  version = "4.11.2";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RSAA4wZRouGPpIekfSXA8cTUb9ByCK2GbV5/mcJ/6eQ=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    sqlite
    wxGTK32
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./samples/minimal -t -s ./samples

    runHook postCheck
  '';

  meta = {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
  };
})
