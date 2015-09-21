{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "ae57260";

  package-name = "numix-icon-theme";

  name = "${package-name}-20150910";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "147a8d9wkhrq4f4154gb0l16rj849lsccxl8npicr6zixvsjgqlq";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
