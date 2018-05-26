# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchFromGitHub, pkgconfig, libsndfile }:

rec {

  vampSDK = stdenv.mkDerivation {
    name = "vamp-sdk-2.7.1";
    # version = "2.7.1";

    src = fetchFromGitHub {
      owner = "c4dm";
      repo = "vamp-plugin-sdk";
      rev = "vamp-plugin-sdk-v2.7.1";
      sha256 = "1ifd6l6b89pg83ss4gld5i72fr0cczjnl2by44z5jnndsg3sklw4";
    };

  nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libsndfile ];

    meta = with stdenv.lib; {
      description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
      homepage = https://sourceforge.net/projects/vamp;
      license = licenses.bsd3;
      maintainers = [ maintainers.goibhniu maintainers.marcweber ];
      platforms = platforms.linux;
    };
  };

}
