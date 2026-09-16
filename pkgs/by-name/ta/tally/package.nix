{
  fetchFromCodeberg,
  glib,
  gobject-introspection,
  lib,
  libadwaita,
  lua5_5,
  stdenv,
  wrapGAppsHook4,
}:
let
  luaEnv = lua5_5.withPackages (
    p: with p; [
      luagobject
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tally";
  version = "0.7.3";

  src = fetchFromCodeberg {
    owner = "vtrlx";
    repo = "tally";
    tag = finalAttrs.version;
    hash = "sha256-ktdhHlOF0k7tuBOvGBQUagB2IzUEGJQT+PXUOerkQOY=";
  };

  patches = [
    # Remove impure Lua paths. PATH and CPATH will be set manually.
    ./remove-impure-paths.patch
  ];

  # Use `$out/data` instead of `/app/data` as package isn't built inside flatkapk.
  postPatch = ''
    substituteInPlace main.lua \
      --replace-fail '/app/data' '${placeholder "out"}/data'
  '';

  nativeBuildInputs = [
    glib # for glib-compile-resources
    gobject-introspection
    luaEnv
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    luaEnv
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    gappsWrapperArgs+=(
      --prefix LUA_PATH ';' '${lua5_5.pkgs.luaLib.genLuaPathAbsStr luaEnv}'
      --prefix LUA_CPATH ';' '${lua5_5.pkgs.luaLib.genLuaCPathAbsStr luaEnv}'
    )
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Keep track of things with tally counters";
    homepage = "https://vtrlx.ca/apps/tally.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "tally";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gnome-circle ];
  };
})
