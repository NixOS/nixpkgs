# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchurl, pkgconfig, libsndfile }:

rec {

  vampSDK = stdenv.mkDerivation {
    name = "vamp-sdk-2.0";

    src = fetchurl {
      url = mirror://sourceforge/vamp/files/vamp-plugin-sdk/2.0/vamp-plugin-sdk-2.0.tar.gz;
      sha256 = "1bxi3dw3zb9896vsx256avzfwpad5csad36cfy5s1zmqkl130mkp";
    };

    buildInputs = [pkgconfig libsndfile];

    meta = { 
      description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
      homepage = http://sourceforge.net/projects/vamp;
      license = "BSD";
      maintainers = [ stdenv.lib.maintainers.marcweber ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

}
