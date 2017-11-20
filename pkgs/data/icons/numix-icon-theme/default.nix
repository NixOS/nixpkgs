{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2017-11-18";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "ea7f2069ca1f6190494e96aa2febcadf6248c5b4";
    sha256 = "1nk0mc2qycwmjqdlrsfgar5m83pyj3hf6f66pywf9706nn2yz8fv";
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
