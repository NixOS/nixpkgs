{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "la-capitaine-icon-theme";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = "la-capitaine-icon-theme";
    rev = "v${version}";
    sha256 = "0cm2scrcg5h45y56h822ywyvfzns1x4wf3gqq96cwb22dc7ny1g9";
  };

  postPatch = ''
    rm configure
  '';

  installPhase = ''
     mkdir -p $out/share/icons/la-capitaine-icon-theme
     mv ./* $out/share/icons/la-capitaine-icon-theme
  '';

  meta = with stdenv.lib; {
    description = "La Capitaine is an icon pack designed to integrate with most desktop environments. The set of icons takes inspiration from the latest iterations of macOS and Google's Material Design.";
    homepage = https://github.com/keeferrourke/la-capitaine-icon-theme;
    license = licenses.gpl3;
    maintainers = [ maintainers.linarcx ];
    platforms = platforms.all;
  };
}
