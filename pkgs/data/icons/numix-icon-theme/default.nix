{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0f7641b048a07eb614662c502eb209dad5eb6d97";

  package-name = "numix-icon-theme";

  name = "${package-name}-20151023";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "16kbasgbb5mgiyl9b240215kivdnl8ynpkxhp5gairba9l4jpbih";
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
