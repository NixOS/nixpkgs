{
  lib,
  buildDunePackage,
  fetchFromCodeberg,
  nix-update-script,
  cmdliner,
  bytesrw,
  fmt,
  eris,
  base32,
  psq,
  lru,
  miou,
  sqlite3,
  astring,
  fpath,
  rresult,
  bos,
  logs,
  uuidm,
  ptime,
  htmlit,
  zarith,
  csexp,
}:

buildDunePackage (finalAttrs: {
  pname = "kapla";
  version = "0.4.0";

  src = fetchFromCodeberg {
    owner = "eris";
    repo = "kapla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xnPBv/20dH+fyNK6J/qJyyFTizhWfvbl6nUA8JzTRco=";
  };

  patches = [
    # Replace with fetchpatch when https://codeberg.org/eris/kapla/pulls/2 is merged
    ./add-rresult-dependency.patch
  ];

  postPatch = ''
    rm -rf vendor
  '';

  nativeBuildInputs = [
    cmdliner
  ];

  buildInputs = [
    cmdliner
    fmt
    bytesrw
    eris
    base32
    psq
    lru
    miou
    sqlite3
    astring
    fpath
    rresult
    bos
    logs
    uuidm
    ptime
    htmlit
    zarith
    csexp
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ERIS block storage and transport";
    homepage = "https://codeberg.org/eris/kapla";
    mainProgram = "kapla";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    teams = [ lib.teams.ngi ];
  };
})
