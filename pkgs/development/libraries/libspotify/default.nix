{ stdenv, fetchurl, libspotify, alsaLib, readline, pkgconfig, apiKey }:

let version = "12.1.51"; in

if stdenv.system != "x86_64-linux" then throw ''
  Check https://developer.spotify.com/technologies/libspotify/ for a tarball for your system and add it here
'' else stdenv.mkDerivation {
  name = "libspotify-${version}";

  src = fetchurl {
    url = "https://developer.spotify.com/download/libspotify/libspotify-${version}-Linux-x86_64-release.tar.gz";

    sha256 = "0n0h94i4xg46hfba95n3ypah93crwb80bhgsg00f6sms683lx8a3";
  };

  buildPhase = "true";

  installFlags = "prefix=$(out)";

  postInstall = "mv -v share $out";

  patchPhase = "sed -i 's/ldconfig//' Makefile";

  passthru = {
    samples = if apiKey == null
      then throw ''
        Please visit ${libspotify.meta.homepage} to get an api key then set config.libspotify.apiKey accordingly
      '' else stdenv.mkDerivation {
        name = "libspotify-samples-${version}";

        src = libspotify.src;

        buildInputs = [ pkgconfig libspotify alsaLib readline ];

        postUnpack = "sourceRoot=$sourceRoot/share/doc/libspotify/examples";

        patchPhase = "cp ${apiKey} appkey.c";

        installPhase = ''
          mkdir -p $out/bin
          install -m 755 jukebox/jukebox $out/bin
          install -m 755 spshell/spshell $out/bin
          install -m 755 localfiles/posix_stu $out/bin
        '';

        meta = libspotify.meta // { description = "Spotify API library samples"; };
      };

    inherit apiKey;
  };

  meta = {
    description = "Spotify API library";

    homepage = https://developer.spotify.com/technologies/libspotify;

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    license = stdenv.lib.licenses.proprietary;
  };
}
