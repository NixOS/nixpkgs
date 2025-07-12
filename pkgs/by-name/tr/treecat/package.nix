{
  fetchFromSourcehut,
  fetchpatch,
  hareHook,
  haredo,
  lib,
  scdoc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "treecat";
  version = "1.0.2-unstable-2023-11-28";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = "treecat";
    rev = "d277aed99eb48eef891b76916a61029989c41d2d";
    hash = "sha256-4A01MAGkBSSzkyRw4omNbLoX8z+pHfoUO7/6QvEUu70=";
  };

  patches = [
    # Update for Hare 0.24.2.
    (fetchpatch {
      url = "https://git.sr.ht/~autumnull/treecat/commit/53ad8126261051dd3b3493c34ae49f23db2c2d16.patch";
      hash = "sha256-cF/lMZjg1hB93rBXcjecT5Rrzb2Y73u6DSW1WcP5Vek=";
    })
  ];

  nativeBuildInputs = [
    hareHook
    haredo
    scdoc
  ];

  env.PREFIX = builtins.placeholder "out";

  dontConfigure = true;

  meta = {
    description = "Serialize a directory to a tree diagram, and vice versa";
    longDescription = ''
      Treecat is an amalgamation of `tree(1)` and `cat(1)`, with the added
      bonus that it can reconstruct its output back into the original filetree.
    '';
    homepage = "https://sr.ht/~autumnull/treecat/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "treecat";
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
