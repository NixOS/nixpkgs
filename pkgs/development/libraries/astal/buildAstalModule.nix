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
        version = "0-unstable-2025-03-17";

        __structuredAttrs = true;
        strictDeps = true;

        src = fetchFromGitHub {
          owner = "Aylur";
          repo = "astal";
          rev = "e5a8e3b60e41d06450284baf7008abe4ac27a53d";
          hash = "sha256-8gWNDDVS7TqLiS+eR1XhfMHBeknmTzLQ3ItB40OK3p0=";
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
