{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.10.12";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    hash = "sha256-3t8SQJdB7ivuCnsr5TxmgslQNkvz+O/mE3NB+R/kXHM=";
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

  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = [ ];
    license = with licenses; [
      lgpl3Plus
      gpl3Plus
    ];
  };
}
