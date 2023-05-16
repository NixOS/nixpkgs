{ fetchFromGitHub
, lib
, stdenvNoCC
, python3
, sassc
, sass
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
<<<<<<< HEAD
  version = "2.1.5";
=======
  version = "2.0.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-l/ePlvdrHUhRz/KBaBgUSA9KF/pufqeCgSAFRR03IKE=";
=======
    hash = "sha256-FvX4r7AZgSq52T9CKE9RagsKgQXExTYPptQBXadA3eI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    python3
    sassc
    sass
  ];

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    mv usr/share $out
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-themes";
    description = "Mint-X and Mint-Y themes for the cinnamon desktop";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
