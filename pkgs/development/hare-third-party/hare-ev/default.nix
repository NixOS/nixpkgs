{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-ev";
  version = "0.26.0.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    tag = finalAttrs.version;
    hash = "sha256-Chetww+F46ZJ+cgVuoFXRVYOT9g13iBK5EembWXQhuc=";
  };

  nativeCheckInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Event loop for Hare programs";
    homepage = "https://sr.ht/~sircmpwn/hare-ev";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ colinsane ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
