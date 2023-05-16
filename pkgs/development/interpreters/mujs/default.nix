{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
, fixDarwinDylibNames
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, readline
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.3.3";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.gz";
    hash = "sha256-4sXuVBbf2iIwx6DLeJXfmpstWyBluxjn5k3sKnlqvhs=";
  };

  buildInputs = [ readline ];

<<<<<<< HEAD
  nativeBuildInputs = lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "install-shared" ];

=======
  makeFlags = [ "prefix=$(out)" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.updateScript = gitUpdater {
    # No nicer place to track releases
    url = "git://git.ghostscript.com/mujs.git";
  };

  meta = with lib; {
    homepage = "https://mujs.com/";
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.isc;
  };
}
