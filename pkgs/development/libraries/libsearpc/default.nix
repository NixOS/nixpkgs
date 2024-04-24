{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, python3
, glib
, jansson
}:

stdenv.mkDerivation rec {
  version = "3.3-20230626";
  commit = "783141fb694f3bd1f8bd8a783670dd25a53b9fc1";
  pname = "libsearpc";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    rev = commit;
    sha256 = "sha256-nYYp3EyA8nufhbWaw4Lv/c4utGYaxC+PoFyamUEVJx4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  propagatedBuildInputs = [
    glib
    jansson
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "A simple and easy-to-use C language RPC framework based on GObject System";
    mainProgram = "searpc-codegen.py";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh ];
  };
}
