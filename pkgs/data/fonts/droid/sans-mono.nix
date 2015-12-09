{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "font-droid-sans-mono";
  buildInputs = [unzip];

  src = fetchurl {
    url = "http://www.fontsquirrel.com/fonts/download/droid-sans-mono";
    sha256 = "0y6scc3y9hjcsvk71sxifrvkhm5w2cg3f09qhgv2zvbxw7j23s8r";
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
    description = "Droid Sans Mono Font by Google Android";
    homepage = [
      http://www.fontsquirrel.com/fonts/list/foundry/google-android
      http://www.droidfonts.com/droidfonts
    ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
