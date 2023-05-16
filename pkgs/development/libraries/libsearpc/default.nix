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
<<<<<<< HEAD
  version = "3.3-20230626";
  commit = "783141fb694f3bd1f8bd8a783670dd25a53b9fc1";
=======
  version = "3.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "libsearpc";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
<<<<<<< HEAD
    rev = commit;
    sha256 = "sha256-nYYp3EyA8nufhbWaw4Lv/c4utGYaxC+PoFyamUEVJx4=";
=======
    rev = "v${version}";
    sha256 = "18i5zvrp6dv6vygxx5nc93mai2p2x786n5lnf5avrin6xiz2j6hd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
<<<<<<< HEAD
=======
  ];

  buildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
