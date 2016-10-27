{ stdenv, fetchFromGitHub, autoreconfHook, moka-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "arc-icon-theme";
  version = "2016-07-07";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = package-name;
    rev = "664c05e723ac2971feb123d7baca3d298248e7f9";
    sha256 = "10vicnrv2v7y4capvllaz9x3nzjkjj9fs1dspjjjg6if3gcif7m4";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ moka-icon-theme ];

  meta = with stdenv.lib; {
    description = "Arc icon theme";
    homepage = https://github.com/horst3180/arc-icon-theme;
    license = with licenses; [ gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
