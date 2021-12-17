{ fetchFromGitHub
, lib
, stdenv
, python3
, sassc
, sass
}:

stdenv.mkDerivation rec {
  pname = "mint-themes";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # they don't exactly do tags, it's just a named commit
    rev = "a833fba6917043bf410dee4364c9a36af1ce4c83";
    hash = "sha256-8abjjD0XoApvqB8SNlWsqIEp7ozgiERGS0kWglw2DWA=";
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
    mkdir -p $out
    mv usr/share $out
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-themes";
    description = "Mint-X and Mint-Y themes for the cinnamon desktop";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
