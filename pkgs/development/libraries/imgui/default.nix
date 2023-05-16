{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "imgui";
<<<<<<< HEAD
  version = "1.89.9";
=======
  version = "1.89.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-0k9jKrJUrG9piHNFQaBBY3zgNIKM23ZA879NY+MNYTU=";
=======
    sha256 = "sha256-Ha70CTSBpyF9S+/qG9lAhUlUT4vY0crOoi3vFsy65H8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include/imgui

    cp *.h $out/include/imgui
    cp *.cpp $out/include/imgui
    cp -a backends $out/include/imgui/
    cp -a misc $out/include/imgui/
  '';

  meta = with lib; {
    description = "Bloat-free Graphical User interface for C++ with minimal dependencies";
    homepage = "https://github.com/ocornut/imgui";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = platforms.all;
  };
}
