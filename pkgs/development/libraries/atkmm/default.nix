{ stdenv, fetchurl, atk, glibmm, pkgconfig }:

stdenv.mkDerivation rec {
  name = "atkmm-2.22.6";

  src = fetchurl {
    url = mirror://gnome/sources/atkmm/2.22/atkmm-2.22.6.tar.xz;
    sha256 = "1dmf72i7jv2a2gavjiah2722bf5qk3hb97hn5dasxqxr0r8jjx0a";
  };

  propagatedBuildInputs = [ atk glibmm ];

  buildNativeInputs = [ pkgconfig ];
}
