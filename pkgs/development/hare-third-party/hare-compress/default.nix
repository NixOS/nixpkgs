{
  lib,
  stdenv,
  hareHook,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-compress";
  version = "0.25.2.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-compress";
    tag = finalAttrs.version;
    hash = "sha256-s5K6xnzQeQ/lncpfZpxHx1FBdrjgnuhOih/YGJXCjkc=";
  };

  nativeBuildInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-compress/";
    description = "Compression algorithms for Hare";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ starzation ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
