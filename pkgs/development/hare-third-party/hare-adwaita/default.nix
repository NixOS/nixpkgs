{
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
  harfbuzz,
  libadwaita,
  pango,
}:
let
  # .gir files are needed during native build
  # .h files are needed for tools depending on this package
  scriptDeps = [
    atk.dev
    gdk-pixbuf.dev
    glib.dev
    gobject-introspection.dev
    graphene.dev
    gtk4.dev
    harfbuzz.dev
    libadwaita.dev
    pango.dev
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hare-adwaita";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-adwaita";
    rev = finalAttrs.version;
    hash = "sha256-E3nlBob3PmWNsfne5yA2qLYzWvrNVfDlMYnWBjYBQh4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    hareHook
    hareThirdParty.hare-gi
  ]
  ++ scriptDeps;
  propagatedBuildInputs = scriptDeps;

  postPatch = ''
    substituteInPlace scripts/generate \
      --replace-fail "/usr/share/gir-1.0/" "gir-1.0/"
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    description = "Hare bindings for libadwaita";
    homepage = "https://git.sr.ht/~sircmpwn/hare-adwaita/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ oliverpool ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
