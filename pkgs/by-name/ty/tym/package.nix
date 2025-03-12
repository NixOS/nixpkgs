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

stdenv.mkDerivation rec {
  pname = "tym";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = "tym";
    rev = version;
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

  meta = with lib; {
    description = "Lua-configurable terminal emulator";
    homepage = "https://github.com/endaaman/tym";
    license = licenses.mit;
    maintainers = with maintainers; [
      wesleyjrz
      kashw2
    ];
    platforms = platforms.linux;
    mainProgram = "tym";
  };
}
