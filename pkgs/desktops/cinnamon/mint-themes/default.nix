{ fetchFromGitHub
, lib
, stdenvNoCC
, python3
, sassc
, sass
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-OgyLNc6gwMn7dG5/T67Toiqsij1rJYV6k6Un2cgr2oQ=";
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
