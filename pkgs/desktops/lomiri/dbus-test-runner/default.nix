{ stdenv, fetchFromGitHub
, autoreconfHook, gnome3, intltool, pkg-config, bustle
, glib, dbus-glib
}:

stdenv.mkDerivation rec {
  pname = "dbus-test-runner-unstable";
  version = "2019-01-09";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "dbus-test-runner";
    rev = "86d63d119566974bd841cacd3202599b3b1a845d";
    sha256 = "08696ab8ldi22s9ch030sdyzp3m8llszcvhm6span41h782708lm";
  };

  buildFlags = [ "CFLAGS=-Wno-error" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook gnome3.gnome-common intltool pkg-config bustle ];

  buildInputs = [ glib dbus-glib ];
}
