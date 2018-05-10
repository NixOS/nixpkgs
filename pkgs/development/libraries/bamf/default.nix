{ stdenv, fetchurl, libgtop, libwnck3, glib, vala, pkgconfig
, libstartup_notification, gobjectIntrospection, gtk-doc
, python27, pythonPackages, libxml2 }:

stdenv.mkDerivation rec {
  pname = "bamf";
  version = "0.5.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/0.5/${version}/+download/${name}.tar.gz";
    sha256 = "051vib8ndp09ph5bfwkgmzda94varzjafwxf6lqx7z1s8rd7n39l";
  };

  nativeBuildInputs = [
    pkgconfig
    gtk-doc
    gobjectIntrospection
  ];

  buildInputs = [ libgtop libwnck3 vala libstartup_notification
                  python27 pythonPackages.libxslt libxml2 glib ];

  postPatch = ''
    substituteInPlace data/Makefile.in \
      --replace '/usr/lib/systemd/user' '@datarootdir@/systemd/user'
  '';

  # fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  # ignore deprecation errors
  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  meta = with stdenv.lib; {
    description = "Application matching framework";
    longDescription = ''
      Removes the headache of applications matching
      into a simple DBus daemon and c wrapper library.
    '';
    homepage = https://launchpad.net/bamf;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}
