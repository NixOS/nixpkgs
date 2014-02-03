{ stdenv, fetchurl, libspotify, alsaLib, readline, pkgconfig, apiKey, unzip, gnused }:

let version = "12.1.51"; in

if (stdenv.system != "x86_64-linux" && stdenv.system != "x86_64-darwin")
then throw "Check https://developer.spotify.com/technologies/libspotify/ for a tarball for your system and add it here"
else stdenv.mkDerivation {
  name = "libspotify-${version}";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url    = "https://developer.spotify.com/download/libspotify/libspotify-${version}-Linux-x86_64-release.tar.gz";
        sha256 = "0n0h94i4xg46hfba95n3ypah93crwb80bhgsg00f6sms683lx8a3";
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url    = "https://developer.spotify.com/download/libspotify/libspotify-${version}-Darwin-universal.zip";
        sha256 = "1gcgrc8arim3hnszcc886lmcdb4iigc08abkaa02l6gng43ky1c0";
      }
    else
      null;

  # common
  buildPhase = "true";
  # no patch or build phase for darwin
  phases = 
    [ "unpackPhase" ] ++ 
    (stdenv.lib.optionals (stdenv.system == "x86_64-linux") [ "patchPhase" "buildPhase" ]) ++
    [ "installPhase" ];
  installPhase = if (stdenv.system == "x86_64-linux")
    then "installPhase"
    else ''
      mkdir -p "$out"/include/libspotify
      mv -v libspotify.framework/Versions/Current/Headers/api.h \
        "$out"/include/libspotify
      mkdir -p "$out"/lib
      mv -v libspotify.framework/Versions/Current/libspotify \
        "$out"/lib/libspotify.dylib
      mkdir -p "$out"/share/man
      mv -v man3 "$out"/share/man
    '';
 

  # darwin-specific
  buildInputs = stdenv.lib.optional (stdenv.system == "x86_64-darwin") unzip;

  # linux-specific
  installFlags = stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
    "prefix=$(out)";
  patchPhase = stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
    "${gnused}/bin/sed -i 's/ldconfig//' Makefile";
  postInstall = stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
    "mv -v share $out";

  passthru = {
    samples = if apiKey == null
      then throw ''
        Please visit ${libspotify.meta.homepage} to get an api key then set config.libspotify.apiKey accordingly
      '' else stdenv.mkDerivation {
        name = "libspotify-samples-${version}";
        src = libspotify.src;
        buildInputs = [ pkgconfig libspotify readline ]
          ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;
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

  meta = with stdenv.lib; {
    description = "Spotify API library";
    homepage    = https://developer.spotify.com/technologies/libspotify;
    maintainers = with maintainers; [ lovek323 ];
    license     = licenses.unfree;
  };
}
