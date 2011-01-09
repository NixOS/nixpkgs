{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.8.7";

  src = fetchurl {
    url = "http://jqueryui.com/download/${name}.custom.zip";
    sha256 = "17j6cmzri6gkrhp4qfnr73sql8qiyxzadrii4ljj62i6vhkb1x2i";
  };

  sourceRoot = ".";

  buildInputs = [ unzip ];

  installPhase =
    ''
      mkdir -p $out
      cp -prvd css js $out/

      # For convenience, provide symlinks "jquery.min.js" etc. (i.e.,
      # without the version number).
      ln -s $out/js/jquery-ui-*.custom.min.js $out/js/jquery-ui.min.js
      ln -s $out/js/jquery-1.*.min.js $out/js/jquery.min.js
      ln -s $out/css/smoothness/jquery-ui-*.custom.css $out/css/smoothness/jquery-ui.css
    '';

  meta = {
    homepage = http://jqueryui.com/;
    description = "A library of JavaScript widgets and effects";
  };
}
