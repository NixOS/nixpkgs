{ autoconf-archive, autoreconfHook, dbus_glib, fetchFromGitHub, gobjectIntrospection, pkgconfig, spidermonkey_52, stdenv }:

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    rev = "${version}";
    sha256 = "1yvzvfm1z0d8ca9vk9s0gbsir0ln7mcmlbczf0hh8vzpsg7m1zk5";
  };

  buildInputs = [ autoconf-archive dbus_glib gobjectIntrospection pkgconfig spidermonkey_52 ];
  nativeBuildInputs = [ autoreconfHook ];
}
