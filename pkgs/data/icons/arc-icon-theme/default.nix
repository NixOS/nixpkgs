{ stdenv, fetchFromGitHub, autoreconfHook, moka-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "arc-icon-theme";
  version = "2016-06-06";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = package-name;
    rev = "69da5eed0761237fd287ea2fc95c708353ccc332";
    sha256 = "04ym3ix2cpjh1q7lwvhl578pv41mn9zsadlsygl0nck8yd22widq";
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
