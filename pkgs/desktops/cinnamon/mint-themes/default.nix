{ fetchFromGitHub
, lib
, stdenv
, python3
, sassc
, sass
}:

stdenv.mkDerivation rec {
  pname = "mint-themes";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # they don't exactly do tags, it's just a named commit
    rev = "38b5606c3889a9a0bac0e2ab39196f675496982c";
    hash = "sha256-Cc5p9WWLFPQ8K0CpL236LilAgBuO6HdfGt/rb0wiVpc=";
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
