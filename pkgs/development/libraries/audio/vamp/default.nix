# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchurl, pkgconfig, libsndfile }:

rec {

  vampSDK = stdenv.mkDerivation {
    name = "vamp-sdk-2.5";

    src = fetchurl {
      url = http://code.soundsoftware.ac.uk/attachments/download/690/vamp-plugin-sdk-2.5.tar.gz;
      sha256 = "178kfgq08cmgdzv7g8dwyjp4adwx8q04riimncq4nqkm8ng9ywbv";
    };

    buildInputs = [ pkgconfig libsndfile ];

    meta = with stdenv.lib; {
      description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
      homepage = http://sourceforge.net/projects/vamp;
      license = licenses.bsd3;
      maintainers = [ maintainers.goibhniu maintainers.marcweber ];
      platforms = platforms.linux;
    };
  };

}
