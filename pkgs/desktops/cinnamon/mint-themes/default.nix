{ fetchFromGitHub
, stdenv
, python3
, sassc
, sass
}:

stdenv.mkDerivation rec {
  pname = "mint-themes";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0a8f2cmcl00y4607v5qr2zdcdjc0z74ixm2yakscvw6qzgsh9fac";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/mint-themes";
    description = "Mint-X and Mint-Y themes for the cinnamon desktop";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
