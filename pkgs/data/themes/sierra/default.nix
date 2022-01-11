{ lib
, stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, librsvg
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "sierra-gtk-theme";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "05899001c4fc2fec87c4d222cb3997c414e0affd";
    sha256 = "174l5mryc34ma1r42pk6572c6i9hmzr9vj1a6w06nqz5qcfm1hds";
  };

  nativeBuildInputs = [
    libxml2
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh --dest $out/share/themes
  '';

  meta = with lib; {
    description = "A Mac OSX like theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Sierra-gtk-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
