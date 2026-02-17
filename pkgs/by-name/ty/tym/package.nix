{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  gtk3,
  vte,
  lua5_3,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tym";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = "tym";
    rev = finalAttrs.version;
    sha256 = "sha256-ySriCBmwDiDmAkIIByaZgmK0nUyYiVb0VAV5bi38JGw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    gtk3
    vte
    lua5_3
    pcre2
  ];

  meta = {
    description = "Lua-configurable terminal emulator";
    homepage = "https://github.com/endaaman/tym";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wesleyjrz
      kashw2
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tym";
  };
})
