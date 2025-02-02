{ stdenv
, fetchFromSourcehut
, hare
, haredo
, lib
, scdoc
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "treecat";
  version = "1.0.2-unstable-2023-11-28";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = "treecat";
    rev = "d277aed99eb48eef891b76916a61029989c41d2d";
    hash = "sha256-4A01MAGkBSSzkyRw4omNbLoX8z+pHfoUO7/6QvEUu70=";
  };

  nativeBuildInputs = [
    hare
    haredo
    scdoc
  ];

  dontConfigure = true;

  preBuild = ''
    HARECACHE="$(mktemp -d)"
    export HARECACHE
    export PREFIX="${builtins.placeholder "out"}"
  '';

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
    inherit (hare.meta) platforms badPlatforms;
  };
})
