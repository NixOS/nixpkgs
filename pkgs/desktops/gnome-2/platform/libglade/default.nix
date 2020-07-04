{ stdenv, fetchurl, pkgconfig, gtk2, libxml2, python2 ? null, withLibgladeConvert ? false, gettext }:

assert withLibgladeConvert -> python2 != null;

stdenv.mkDerivation {
  name = "libglade-2.6.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2";
    sha256 = "1v2x2s04jry4gpabws92i0wq2ghd47yr5n9nhgnkd7c38xv1wdk4";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 gettext ]
    ++ stdenv.lib.optional withLibgladeConvert python2;

  NIX_LDFLAGS = "-lgmodule-2.0";

  propagatedBuildInputs = [ libxml2 ];
}
