# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchFromGitHub, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  pname = "vamp-plugin-sdk";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "c4dm";
    repo = "vamp-plugin-sdk";
    rev = "vamp-plugin-sdk-v${version}";
    sha256 = "1lhmskcyk7qqfikmasiw7wjry74gc8g5q6a3j1iya84yd7ll0cz6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndfile ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
    homepage = "https://vamp-plugins.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
