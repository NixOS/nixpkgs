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
<<<<<<< HEAD
  version = "4.11.1";
=======
  version = "4.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fhhE7nPYNnqvtSCL0Z8v8mcF4gxrmE3lpCd9ji01PQ4=";
=======
    hash = "sha256-cTErixQhAruU/mpxnG4Nio4PPtxSeGeNZNHTjZlyn+M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = with lib.licenses; [
=======
  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = [ ];
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl3Plus
      gpl3Plus
    ];
  };
}
