{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.8.9";

  src = fetchurl {
    url = "http://jqueryui.com/download/${name}.custom.zip";
    sha256 = "1fnn5xwj57bdf9z786iymcxa7c4qf6mv4jm5m7q52j72by8gf011";
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
