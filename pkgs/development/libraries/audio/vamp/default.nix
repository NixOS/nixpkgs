# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchurl, pkgconfig, libsndfile }:

rec {

  vampSDK = stdenv.mkDerivation {
    name = "vamp-sdk-2.2.1";

    src = fetchurl {
      url = mirror://sourceforge/vamp/files/vamp-plugin-sdk/2.0/vamp-plugin-sdk-2.2.1.tar.gz;
      sha256 = "09iw6gv8aqq5v322fhi872mrhjp0a2w63966g0mks4vhh84q252p";
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
