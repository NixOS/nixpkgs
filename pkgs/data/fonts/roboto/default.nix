{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "font-roboto";
  buildInputs = [unzip];

  src = fetchurl {
    url = "https://material-design.storage.googleapis.com/publish/material_v_4/material_ext_publish/0B0J8hsRkk91LRjU4U1NSeXdjd1U/RobotoTTF.zip";
    sha256 = "a89ac9f0c925926f3bd7428b441d1ea9b48bc1086c8829d947428ffdce9d94ba";
  };

  dontBuild = true;

  sourceRoot = "./";

  installPhase =
    ''
      mkdir -p $out/share/fonts/roboto
      cp *.ttf $out/share/fonts/roboto
    '';

  meta = {
    description = "Roboto is a neo-grotesque sans-serif typeface family developed 
    by Google as the system font for its mobile operating system Android.";
    homepage = https://www.google.com/design/spec/resources/roboto-noto-fonts.html;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
