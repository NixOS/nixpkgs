{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.11.1";

  src = fetchurl {
    url = "http://jqueryui.com/resources/download/${name}.zip";
    sha256 = "05dlcfwklymx94fb4n88l5syf80l6zrs862zzmla477vd8ndk537";
  };

  buildInputs = [ unzip ];

  installPhase =
    ''
      mkdir -p "$out/js"
      cp -rv . "$out/js"
    '';

  meta = {
    homepage = http://jqueryui.com/;
    description = "A library of JavaScript widgets and effects";
    platforms = stdenv.lib.platforms.all;
  };
}
