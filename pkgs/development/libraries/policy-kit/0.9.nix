args: with args;

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "PolicyKit-0.9";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "f40c7c6bec19d7dba2335bddcffd0457494409a0dfce11d888c748dc892e80b7";
  };
  
  buildInputs = [
   pkgconfig expat intltool glib dbus dbus_glib pam gettext
  ];
}
