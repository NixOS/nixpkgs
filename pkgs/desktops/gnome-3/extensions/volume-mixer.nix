{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  name = "gnome-shell-volume-mixer-${version}";
  version = "844ed80ad448855d8f6218847183a80474b523c7";

  src = fetchFromGitHub {
    owner = "aleho";
    repo = "gnome-shell-volume-mixer";
    rev = version;
    sha256 = "1vcj2spbymhdi1nazvhldvcfgad23r3h7f0ihh4nianbxn7hjs9w";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    ${glib.dev}/bin/glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
  '';

  installPhase = ''
    cp -r ${uuid} $out
  '';

  uuid = "shell-volume-mixer@derhofbauer.at";

  meta = with stdenv.lib; {
    description = "GNOME Shell Extension allowing separate configuration of PulseAudio devices";
    license = licenses.gpl2;
    maintainers = with maintainers; [ aneeshusa ];
    homepage = https://github.com/aleho/gnome-shell-volume-mixer;
  };
}
