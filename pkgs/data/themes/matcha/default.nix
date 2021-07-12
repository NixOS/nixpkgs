{ lib, stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "matcha-gtk-theme";
  version = "2021-07-08";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-iTwPN31JvpFlCBWikOeSTda2wBEtg6ygy8o6ovqHPCw=";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    install -D -t $out/share/gtksourceview-3.0/styles src/extra/gedit/matcha.xml
    mkdir -p $out/share/doc/${pname}
    cp -a src/extra/firefox $out/share/doc/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A stylish flat design theme for GTK based desktop environments";
    homepage = "https://vinceliuice.github.io/theme-matcha";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
