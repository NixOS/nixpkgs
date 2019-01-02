{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2019-01-02";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "053bfc5pslwpqhn05dzznh236g1z4cnn2dzwvb914f6m855fbxfg";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = https://github.com/vinceliuice/Mojave-gtk-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
