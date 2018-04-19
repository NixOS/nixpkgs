# set VAMP_PATH ?
# plugins available on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchFromGitHub, pkgconfig, libsndfile }:

rec {

  vampSDK = stdenv.mkDerivation rec {
    name = "vamp-sdk-${version}";

    src = fetchFromGitHub {
      owner = "c4dm";
      repo = "vamp-plugin-sdk";
      rev = "vamp-plugin-sdk-v${version}";
      sha256 = "1ifd6l6b89pg83ss4gld5i72fr0cczjnl2by44z5jnndsg3sklw4";
    };

    nativeBuildInputs = [ pkgconfig ];

    buildInputs = [ libsndfile ];

    meta = with stdenv.lib; {
      description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
      homepage = https://sourceforge.net/projects/vamp;
      license = licenses.bsd3;
      maintainers = with maintainers; [ goibhniu marcweber ];
      platforms = platforms.linux;
    };
  };
}
