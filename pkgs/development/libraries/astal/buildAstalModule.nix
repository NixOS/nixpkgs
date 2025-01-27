{
  lib,
  stdenv,
  fetchFromGitHub,

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
        version = "0-unstable-2025-01-13";

        __structuredAttrs = true;
        strictDeps = true;

        src = fetchFromGitHub {
          owner = "Aylur";
          repo = "astal";
          rev = "cac0fc63bfe098b26753db8262f5d95ac42b281b";
          hash = "sha256-kNtKWbQ+gMzmAF7KNSZ4Hb8/2cfSNoURCyRSB0nx2I4=";
        };

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
