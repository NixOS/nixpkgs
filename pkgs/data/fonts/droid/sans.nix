{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "font-droid-sans";
  buildInputs = [unzip];

  src = fetchurl {
    url = "http://www.fontsquirrel.com/fonts/download/droid-sans";
    sha256 = "1zba46plg5sbp2y392zcpk3v7w03dcgkw8v6nk5d24dv27vk1k4g";
  };

  dontBuild = true;

  sourceRoot = "./";

  unpackCmd = ''
     ${unzip}/bin/unzip $curSrc
  '';

  installPhase =
    ''
      mkdir -p $out/share/fonts/droid
      cp *.ttf $out/share/fonts/droid
    '';

  meta = {
    description = "Droid Sans Font by Google Android";
    homepage = [
      http://www.fontsquirrel.com/fonts/list/foundry/google-android
      http://www.droidfonts.com/droidfonts
    ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
