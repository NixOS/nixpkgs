{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "font-droid-serif";
  buildInputs = [unzip];

  src = fetchurl {
    url = "http://www.fontsquirrel.com/fonts/download/droid-serif";
    sha256 = "1drnz63bjc291gbd7dy5ycx9isx1ghmzbbghg716ghqgnjlyiw0c";
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
    description = "Droid Serif Font by Google Android";
    homepage = [
      http://www.fontsquirrel.com/fonts/list/foundry/google-android
      http://www.droidfonts.com/droidfonts
    ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
