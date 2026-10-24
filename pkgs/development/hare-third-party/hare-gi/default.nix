{
  fetchFromSourcehut,
  fetchpatch,
  hareHook,
  lib,
  stdenv,

  atk,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  harfbuzz,
  pango,
  gtk3,
  gtk4,
  graphene,
}:
let
  # .gir files are needed during native build
  # .h files are needed for tools depending on this package
  scriptDeps = [
    # for scripts/generate-gtk{3,4}
    atk.dev
    gdk-pixbuf.dev
    glib.dev
    gobject-introspection.dev
    harfbuzz.dev
    pango.dev
    # generate-gtk3
    gtk3.dev
    # generate-gtk4
    gtk4.dev
    graphene.dev
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-gi";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~yerinalexey";
    repo = "hare-gi";
    rev = finalAttrs.version;
    hash = "sha256-L9BatUF+5SJhkFpzvjkDGMk2bSlQCv4ed2W5gJz6P+4=";
  };

  patches = [
    (fetchpatch {
      url = "https://lists.sr.ht/~yerinalexey/public-inbox/patches/72004/mbox";
      hash = "sha256-Ws+Z349H1aGo/AOQFWXXHl5Sj46bBXjTzXK8Z7VVz0s=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ hareHook ] ++ scriptDeps;
  propagatedBuildInputs = scriptDeps;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    description = "GObject Introspection code generator for Hare";
    homepage = "https://sr.ht/~yerinalexey/hare-gi/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ oliverpool ];
    inherit (hareHook.meta) platforms badPlatforms;
    mainProgram = "hare-gi";
  };
})
