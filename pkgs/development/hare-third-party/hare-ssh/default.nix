{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-ssh";
  version = "0.26.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ssh";
    tag = finalAttrs.version;
    hash = "sha256-msPY8m7/GDKsGDrhZ1IK65U+6fcI26FW9CONC4w87Pg=";
  };

  nativeBuildInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-ssh/";
    description = "SSH client & server protocol implementation for Hare";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ patwid ];

    inherit (hareHook.meta) platforms badPlatforms;
  };
})
