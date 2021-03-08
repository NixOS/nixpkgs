{ stdenv, fetchurl, pkg-config, intltool, gtkmm2, libglade }:

stdenv.mkDerivation rec {
  name = "libglademm-2.6.7";

  src = fetchurl {
    url = "mirror://gnome/sources/libglademm/2.6/${name}.tar.bz2";
    sha256 = "1hrbg9l5qb7w0xvr7013qamkckyj0fqc426c851l69zpmhakqm1q";
  };

  outputs = [ "out" "devdoc" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool ];

  propagatedBuildInputs = [ gtkmm2 libglade ];
}
