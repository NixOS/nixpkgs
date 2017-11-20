{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "papirus-icon-theme-${version}";
  version = "20171102";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    rev = "${version}";
    sha256 = "10q7ppizzqi8c564jydqivia43gp4j1z984igfyym2mdwdw71mzq";
  };

  dontBuild = true;

  installPhase = ''
     install -dm 755 $out/share/icons
     cp -dr Papirus{,-Dark,-Light} $out/share/icons/
     cp -dr ePapirus $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Papirus icon theme for Linux";
    homepage = https://github.com/PapirusDevelopmentTeam/papirus-icon-theme;
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
