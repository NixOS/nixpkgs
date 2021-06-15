{ fetchFromGitHub
, lib, stdenv
, python3
, sassc
, sass
}:

stdenv.mkDerivation rec {
  pname = "mint-themes";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # commit is named 1.8.6, tags=404
    rev = "fa0b9530f6e68c390aecd622b229072fcd08f05f";
    sha256 = "0pgv5hglsscip5s7nv0mn301vkn0j6wp4rv34vr941yai1jfk2wb";
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
