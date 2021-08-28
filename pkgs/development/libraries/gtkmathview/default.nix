{lib, stdenv, fetchurl, pkg-config, gtk2, t1lib, glib, libxml2, popt, gmetadom ? null }:

let
  pname = "gtkmathview";
  version = "0.8.0";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://helm.cs.unibo.it/mml-widget/sources/${pname}-${version}.tar.gz";
    sha256 = "0hwcamf5fi35frg7q6kgisc9v0prqbhsplb2gl55cg3av9sh3hqx";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ t1lib glib gmetadom libxml2 popt];
  propagatedBuildInputs = [gtk2 t1lib];

  patches = [ ./gcc-4.3-build-fixes.patch ./gcc-4.4-build-fixes.patch ];

  meta = {
    homepage = "http://helm.cs.unibo.it/mml-widget/";
    description = "C++ rendering engine for MathML documents";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.roconnor ];
    broken = true;
  };
}
