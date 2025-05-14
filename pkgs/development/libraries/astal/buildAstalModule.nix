{
  lib,
  stdenv,
  source, # this is ./source.nix

  glib,
  wrapGAppsHook3,
  gobject-introspection,
  meson,
  pkg-config,
  ninja,
  vala,
  wayland,
  wayland-scanner,
  python3,
}:
let
  cleanArgs = lib.flip builtins.removeAttrs [
    "name"
    "sourceRoot"
    "nativeBuildInputs"
    "buildInputs"
    "website-path"
    "meta"
  ];

  buildAstalModule =
    {
      name,
      sourceRoot ? "lib/${name}",
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      website-path ? name,
      meta ? { },
      ...
    }@args:
    stdenv.mkDerivation (
      finalAttrs:
      cleanArgs args
      // {
        pname = "astal-${name}";
        inherit (source) version;

        __structuredAttrs = true;
        strictDeps = true;

        src = source;

        sourceRoot = "${finalAttrs.src.name}/${sourceRoot}";

        nativeBuildInputs = nativeBuildInputs ++ [
          wrapGAppsHook3
          gobject-introspection
          meson
          pkg-config
          ninja
          vala
          wayland
          wayland-scanner
          python3
        ];

        buildInputs = [ glib ] ++ buildInputs;

        meta = {
          homepage = "https://aylur.github.io/astal/guide/libraries/${website-path}";
          license = lib.licenses.lgpl21;
          maintainers = with lib.maintainers; [ perchun ];
          platforms = [
            "aarch64-linux"
            "x86_64-linux"
          ];
        } // meta;
      }
    );
in

args:
# to support (finalAttrs: {...})
if builtins.typeOf args == "function" then
  buildAstalModule (lib.fix args)
else
  buildAstalModule args
