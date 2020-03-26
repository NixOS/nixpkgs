# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchFromGitHub, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  pname = "vamp-plugin-sdk";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "c4dm";
    repo = "vamp-plugin-sdk";
    rev = "vamp-plugin-sdk-v${version}";
    sha256 = "1ay12gjqp2wzysg9k2qha3gd8sj5rjlfy4hsl923csi4ssiapsh1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndfile ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
    homepage = https://vamp-plugins.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
