{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "proj-datumgrid";
  version = "world-1.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "proj-datumgrid";
    rev = version;
    sha256 = "132wp77fszx33wann0fjkmi1isxvsb0v9iw0gd9sxapa9h6hf3am";
  };

<<<<<<< HEAD
  sourceRoot = "${src.name}/scripts";
=======
  sourceRoot = "source/scripts";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildPhase = ''
    $CC nad2bin.c -o nad2bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nad2bin $out/bin/
  '';

  meta = with lib; {
    description = "Repository for proj datum grids";
    homepage = "https://proj4.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "nad2bin";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
