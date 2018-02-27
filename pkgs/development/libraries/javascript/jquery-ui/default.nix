{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.12.1";

  src = fetchurl {
    url = "http://jqueryui.com/resources/download/${name}.zip";
    sha256 = "0kb21xf38diqgxcdi1z3s9ssq36pldvyqxy56hn6pcva6rs3c8zq";
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
