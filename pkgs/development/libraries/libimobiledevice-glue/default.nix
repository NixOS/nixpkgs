{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.pre+date=2022-05-22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
<<<<<<< HEAD
    rev = version;
    hash = "sha256-9TjIYz6w61JaJgOJtWteIDk9bO3NnXp/2ZJwdirFcYM=";
=======
    rev = "d2ff7969dcd0a12e4f18f63dab03e6cd03054fcb";
    hash = "sha256-BAdpJK6/iUKCNYLaCJQo0VK63AdIafO8wGbNhnvEc/o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

<<<<<<< HEAD
  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
=======
  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project.";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
