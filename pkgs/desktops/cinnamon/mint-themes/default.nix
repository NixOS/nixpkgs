{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  python3,
  sassc,
  sass,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-Acf9cwTKDUF1WwIqT3BR8wFpfUNRyZ+8anOIIg3O3CQ=";
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
