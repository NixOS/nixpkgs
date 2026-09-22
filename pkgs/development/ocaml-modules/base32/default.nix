{
  lib,
  buildDunePackage,
  fetchFromCodeberg,
  nix-update-script,
  alcotest,
  qcheck,
  qcheck-alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "base32";
  version = "1.0.0";

  src = fetchFromCodeberg {
    owner = "pukkamustard";
    repo = "ocaml-base32";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YREcrUF2EdNjO+8W4rNbELh+yH5DlLFsbeiEbtmjijE=";
  };

  doCheck = true;
  checkInputs = [
    alcotest
    qcheck
    qcheck-alcotest
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Base32 for Ocaml";
    homepage = "https://codeberg.org/pukkamustard/ocaml-base32";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
