{ lib, stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "vimix-gtk-themes";
  version = "2020-11-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1m84p4cs9dfwc27zfjnwgkfdnfmlzbimq3g5z4mhz23cijm178rf";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    rm $out/share/themes/*/{AUTHORS,LICENSE}
  '';

  meta = with lib; {
    description = "Flat Material Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/vimix-gtk-themes";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
