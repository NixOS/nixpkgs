{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
    name = "papirus-icon-theme-${version}";
    version = "20170616";

    src = fetchFromGitHub {
        owner = "PapirusDevelopmentTeam";
        repo = "papirus-icon-theme";
        rev = "9be3f0f688f33d538f135b590579466946d0bf4c";
        sha256 = "008nkmxp3f9qqljif3v9ns3a8mflzffv2mm5zgjng9pmdl5x70j4";
    };

    dontBuild = true;

    installPhase = ''
        install -dm 755 $out/share/icons
        cp -dr --no-preserve='ownership' Papirus{,-Dark,-Light} $out/share/icons/
        cp -dr --no-preserve='ownership' ePapirus $out/share/icons/
        
    '';

    meta = with stdenv.lib; {
        description = "Papirus icon theme for Linux";
        homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
        license = licenses.lgpl3;
        platforms = platforms.all;
    };
}
