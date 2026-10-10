{
  buildEnv,
  fetchFromSourcehut,
  hareHook,
  hareThirdParty,
  lib,
  stdenv,

  atk,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  graphene,
  gtk4,
  gtk4-layer-shell,
  harfbuzz,
  pango,
}:
let
  usrShare = buildEnv {
    name = "usr-share";
    paths = [
      atk.dev
      gdk-pixbuf.dev
      glib.dev
      gobject-introspection.dev
      graphene.dev
      graphene.dev
      gtk4-layer-shell.dev
      gtk4.dev
      harfbuzz.dev
      pango.dev
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-gtk4-layer-shell";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-gtk4-layer-shell";
    rev = finalAttrs.version;
    hash = "sha256-320TRtkZnaN0IY/RYyCnd+TEr5I+WBN5CWYTGb7covg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    hareHook
    hareThirdParty.hare-gi
  ];

  propagatedBuildInputs = [ gtk4-layer-shell ];

  postPatch = ''
    substituteInPlace scripts/generate \
      --replace-fail "/usr/share/gir-1.0/" "${usrShare}/share/gir-1.0/"
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    description = "gtk4-layer-shell bindings for Hare";
    homepage = "https://git.sr.ht/~sircmpwn/hare-gtk4-layer-shell";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ oliverpool ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
