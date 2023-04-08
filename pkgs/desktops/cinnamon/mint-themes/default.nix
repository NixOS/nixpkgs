{ fetchFromGitHub
, lib
, stdenvNoCC
, python3
, sassc
, sass
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-FvX4r7AZgSq52T9CKE9RagsKgQXExTYPptQBXadA3eI=";
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
