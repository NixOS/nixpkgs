{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.10.3";

  src = fetchurl {
    url = "http://jqueryui.com/resources/download/${name}.custom.zip";
    sha256 = "1nqh3fmjgy73cbwb5sj775242i6jhz3f5b9fxgrkq00dfvkls779";
  };

  buildInputs = [ unzip ];

  installPhase =
    ''
      mkdir -p $out
      cp -prvd css js $out/

      # For convenience, provide symlinks "jquery.min.js" etc. (i.e.,
      # without the version number).
      pushd $out/js
      ln -s jquery-ui-*.custom.js jquery-ui.js
      ln -s jquery-ui-*.custom.min.js jquery-ui.min.js
      ln -s jquery-1.*.js jquery.js
      popd
      pushd $out/css/smoothness
      ln -s jquery-ui-*.custom.css jquery-ui.css
    '';

  meta = {
    homepage = http://jqueryui.com/;
    description = "A library of JavaScript widgets and effects";
    platforms = stdenv.lib.platforms.all;
  };
}
