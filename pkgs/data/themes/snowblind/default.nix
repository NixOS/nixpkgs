{ stdenv, fetchFromGitLab, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "snowblind";
  version = "2020-02-26";

  src = fetchFromGitLab {
    domain = "www.opencode.net";
    owner = "ju1464";
    repo = pname;
    rev = "94c35410be5cccc142c9cd6be9dff973ce0761c4";
    sha256 = "1aqmpg1vyqwp6s6iikp5c5yfrvdkzq75jdr9mmv2ijcam1g0jhnv";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Snowblind* $out/share/themes
    rm $out/share/themes/*/{COPYING,CREDITS}
  '';

  meta = with stdenv.lib; {
    description = "Smooth blue theme based on Materia Design";
    homepage = "https://www.opencode.net/ju1464/Snowblind";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
