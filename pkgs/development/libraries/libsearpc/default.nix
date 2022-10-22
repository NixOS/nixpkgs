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
  version = "3.2.0";
  pname = "libsearpc";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    rev = "v${version}";
    sha256 = "18i5zvrp6dv6vygxx5nc93mai2p2x786n5lnf5avrin6xiz2j6hd";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    python3
  ];

  propagatedBuildInputs = [
    glib
    jansson
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "A simple and easy-to-use C language RPC framework based on GObject System";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh ];
  };
}
