a:

let
  inherit (a) stdenv fetchurl pkgconfig cg;
  inherit (a.gtkLibs) gtk;
in

stdenv.mkDerivation rec {
  name = "libiodbc-3.52.7";

  src = fetchurl {
    url = "${meta.homepage}/downloads/iODBC/${name}.tar.gz";
    sha256 = "d7002cc7e566785f1203f6096dcb49b0aad02a9d9946a8eca5d663ac1a85c0c7";
  };

  buildInputs = if cg "gtk" false then [ gtk pkgconfig ] else [];

  meta = {
    description = "iODBC driver manager";
    homepage = http://www.iodbc.org;
  };
}
