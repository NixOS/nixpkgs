{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
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
stdenv.mkDerivation rec {
  pname = "vis";
  version = "0.9-unstable-2026-10-03";

  src = fetchFromGitHub {
    rev = "bd0bb3449e6eef991d507689c4bfba53c14fd9c5";
    hash = "sha256-uRGTH5yQGo8O3LahArbSq1uLkH0LZ6rWJqa5S7P50Gg=";
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
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
      --prefix LUA_CPATH ';' "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH ';' "${luaEnv}/share/lua/${lua.luaversion}/?.lua" \
      --prefix VIS_PATH : "\$HOME/.config:$out/share/vis"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vis";
      exec = "vis %U";
      type = "Application";
      icon = "accessories-text-editor";
      comment = meta.description;
      desktopName = "vis";
      genericName = "Text editor";
      categories = [
        "Application"
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
}
