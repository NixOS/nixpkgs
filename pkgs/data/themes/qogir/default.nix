{ lib, stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "qogir-theme";
  version = "2021-08-02";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-U048qNBfxjx/5iHIXcqAwXfIwmux+sw4hVQkN3TDLzk=";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    mkdir -p $out/share/doc/${pname}
    cp -a src/firefox $out/share/doc/${pname}
    rm $out/share/themes/*/{AUTHORS,COPYING}
  '';

  meta = with lib; {
    description = "Flat Design theme for GTK based desktop environments";
    homepage = "https://vinceliuice.github.io/Qogir-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
