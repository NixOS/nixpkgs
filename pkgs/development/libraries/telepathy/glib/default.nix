{ stdenv, fetchurl, dbus-glib, glib, python2, pkgconfig, libxslt
, gobjectIntrospection, vala, glibcLocales }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.24.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "1symyzbjmxvksn2ifdkk50lafjm2llf2sbmky062gq2pz3cg23cy";
  };

  configureFlags = [
    "--enable-vala-bindings"
  ];
  LC_ALL = "en_US.UTF-8";
  propagatedBuildInputs = [ dbus-glib glib ];

  nativeBuildInputs = [ pkgconfig libxslt gobjectIntrospection vala ];
  buildInputs = [ glibcLocales python2 ];

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace telepathy-glib/telepathy-glib.pc.in --replace Requires.private Requires
  '';

  passthru.python = python2;

  meta = {
    homepage = https://telepathy.freedesktop.org;
    platforms = stdenv.lib.platforms.unix;
  };
}
