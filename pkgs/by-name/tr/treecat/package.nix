{
  fetchFromSourcehut,
  hareHook,
  haredo,
  lib,
  scdoc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "treecat";
  version = "1.0.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = "treecat";
    tag = finalAttrs.version;
    hash = "sha256-UCGx1v+AP9BeAktrniTXctkPp5mprf77fkapdhPWrqg=";
  };

  nativeBuildInputs = [
    hareHook
    haredo
    scdoc
  ];

  env.PREFIX = placeholder "out";

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
