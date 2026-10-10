{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  ncurses,
  libtermkey,
  lua5_2_compat,
  tre,
  acl,
  libselinux,
}:

let
  lua = lua5_2_compat;
  luaEnv = lua.withPackages (ps: [ ps.lpeg ]);
in
stdenv.mkDerivation (finalAttrs:{
  pname = "vis";
  version = "0.9-unstable-2026-10-03";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    rev = "bd0bb3449e6eef991d507689c4bfba53c14fd9c5";
    hash = "sha256-uRGTH5yQGo8O3LahArbSq1uLkH0LZ6rWJqa5S7P50Gg=";
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    copyDesktopItems
  ];

  buildInputs = [
    ncurses
    luaEnv
    tre
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
    libselinux
  ];

  postInstall = ''
    wrapProgram $out/bin/vis \
      --prefix LUA_CPATH ';' "${lua.pkgs.luaLib.genLuaCPathAbsStr luaEnv}" \
      --prefix LUA_PATH ';' "${lua.pkgs.luaLib.genLuaPathAbsStr luaEnv}" \
      --prefix VIS_PATH : "\$HOME/.config:$out/share/vis"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vis";
      exec = "vis %U";
      type = "Application";
      icon = "accessories-text-editor";
      comment = finalAttrs.meta.description;
      desktopName = "vis";
      genericName = "Text editor";
      categories = [
        "Development"
        "IDE"
      ];
      mimeTypes = [
        "text/plain"
        "application/octet-stream"
      ];
      startupNotify = false;
      terminal = true;
    })
  ];

  meta = {
    description = "Vim like editor";
    homepage = "https://github.com/martanne/vis";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      ramkromberg
      es-sai-fi
    ];
    platforms = lib.platforms.unix;
    mainProgram = "vis";
  };
})
